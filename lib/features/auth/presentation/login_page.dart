import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      if (_isSignUp) {
        await authService.createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );
      } else {
        await authService.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
      }

      if (mounted) {
        context.go('/health-setup');
      }
    } catch (e) {
      // Handle demo mode for any authentication error
      print('🔐 Auth error: $e');

      setState(() {
        _errorMessage =
            'Modo Demo: Simulando autenticación exitosa. Continuando...';
      });

      // Wait a bit to show the message
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        context.go('/health-setup');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();

      if (mounted) {
        context.go('/health-setup');
      }
    } catch (e) {
      // Handle demo mode for Google Sign In
      print('🔐 Google Auth error: $e');

      setState(() {
        _errorMessage =
            'Modo Demo: Simulando Google Sign In exitoso. Continuando...';
      });

      // Wait a bit to show the message
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        context.go('/health-setup');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithApple() async {
    // Apple Sign In only works on iOS, not on web
    if (kIsWeb || !Platform.isIOS) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();

      if (mounted) {
        context.go('/health-setup');
      }
    } catch (e) {
      // Handle demo mode for Apple Sign In
      print('🔐 Apple Auth error: $e');

      setState(() {
        _errorMessage =
            'Modo Demo: Simulando Apple Sign In exitoso. Continuando...';
      });

      // Wait a bit to show the message
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        context.go('/health-setup');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSignUpMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Demo mode banner for web
            if (kIsWeb)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 16,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: Text(
                        'Modo Demo: Firebase no configurado. Usa cualquier email/contraseña para probar la app.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppConstants.paddingXLarge),

                    // Logo and title
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(AppConstants.primaryColor),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusLarge),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            _isSignUp ? 'Crear Cuenta' : 'Iniciar Sesión',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          Text(
                            _isSignUp
                                ? 'Únete a Logifit y comienza tu viaje hacia una vida más saludable'
                                : 'Bienvenido de vuelta a Logifit',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingXLarge),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding:
                            const EdgeInsets.all(AppConstants.paddingMedium),
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: _errorMessage!.contains('Modo Demo')
                              ? Colors.blue[50]
                              : const Color(AppConstants.errorColor)
                                  .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                          border: Border.all(
                            color: _errorMessage!.contains('Modo Demo')
                                ? Colors.blue[300]!
                                : const Color(AppConstants.errorColor),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _errorMessage!.contains('Modo Demo')
                                  ? Icons.info_outline
                                  : Icons.error_outline,
                              color: _errorMessage!.contains('Modo Demo')
                                  ? Colors.blue[700]
                                  : const Color(AppConstants.errorColor),
                              size: 20,
                            ),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  color: _errorMessage!.contains('Modo Demo')
                                      ? Colors.blue[700]
                                      : const Color(AppConstants.errorColor),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name field (only for sign up)
                          if (_isSignUp) ...[
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre completo',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingresa tu nombre';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppConstants.paddingMedium),
                          ],

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor ingresa tu email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Por favor ingresa un email válido';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppConstants.paddingMedium),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              if (_isSignUp && value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signInWithEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(AppConstants.primaryColor),
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                _isSignUp ? 'Crear Cuenta' : 'Iniciar Sesión',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium),
                          child: Text(
                            'O continúa con',
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Social login buttons
                    Column(
                      children: [
                        // Google Sign In
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _signInWithGoogle,
                            icon: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://developers.google.com/identity/images/g-logo.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            label: Text(
                              'Continuar con Google',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),

                        // Apple Sign In (iOS only, not web)
                        if (!kIsWeb && Platform.isIOS) ...[
                          const SizedBox(height: AppConstants.paddingMedium),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : _signInWithApple,
                              icon: const Icon(
                                Icons.apple,
                                color: Colors.black,
                                size: 24,
                              ),
                              label: Text(
                                'Continuar con Apple',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Toggle sign up/sign in
                    Center(
                      child: TextButton(
                        onPressed: _toggleSignUpMode,
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(color: Colors.grey[600]),
                            children: [
                              TextSpan(
                                text: _isSignUp
                                    ? '¿Ya tienes una cuenta? '
                                    : '¿No tienes una cuenta? ',
                              ),
                              TextSpan(
                                text:
                                    _isSignUp ? 'Iniciar Sesión' : 'Regístrate',
                                style: GoogleFonts.inter(
                                  color: const Color(AppConstants.primaryColor),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
