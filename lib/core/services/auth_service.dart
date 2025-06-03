import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../shared/models/user_model.dart';

enum AuthStatus { authenticated, unauthenticated, loading, error }

class AuthService {
  late final FirebaseAuth _firebaseAuth;
  late final GoogleSignIn _googleSignIn;

  AuthService() {
    try {
      _firebaseAuth = FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn();
    } catch (e) {
      if (kDebugMode) {
        print('Firebase not initialized properly: $e');
      }
    }
  }

  // Check if Firebase is available
  bool get _isFirebaseAvailable {
    try {
      return _firebaseAuth != null;
    } catch (e) {
      return false;
    }
  }

  // Current user stream
  Stream<User?> get authStateChanges {
    if (!_isFirebaseAvailable) {
      // Return a stream that immediately emits null for demo mode
      return Stream.value(null);
    }
    try {
      return _firebaseAuth.authStateChanges();
    } catch (e) {
      // If Firebase fails, return a stream with null
      return Stream.value(null);
    }
  }

  // Current user
  User? get currentUser {
    if (!_isFirebaseAvailable) {
      return null;
    }
    return _firebaseAuth.currentUser;
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    if (!_isFirebaseAvailable) {
      throw Exception('Firebase no está disponible en esta plataforma');
    }

    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Create account with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    if (!_isFirebaseAvailable) {
      throw Exception('Firebase no está disponible en esta plataforma');
    }

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(displayName);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null; // User canceled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  // Sign in with Apple (iOS only)
  Future<UserCredential?> signInWithApple() async {
    if (!Platform.isIOS) {
      throw Exception('Apple Sign In is only available on iOS');
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _firebaseAuth.signInWithCredential(oauthCredential);
    } catch (e) {
      throw Exception('Error signing in with Apple: $e');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Convert Firebase User to UserModel
  UserModel? get currentUserModel {
    final user = currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastLoginAt: user.metadata.lastSignInTime,
      preferences: const UserPreferences(),
      connectedServices: [],
    );
  }

  // Handle Firebase Auth exceptions
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email';
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Provider for auth state
final authStateProvider = StreamProvider<User?>((ref) {
  try {
    return ref.read(authServiceProvider).authStateChanges;
  } catch (e) {
    // If Firebase is not available, return a stream that emits null immediately
    return Stream.value(null);
  }
});

// Provider for current user model
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.read(authServiceProvider).currentUserModel;
});
