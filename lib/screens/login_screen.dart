import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/app_providers.dart';
import '../widgets/animated_scale_button.dart';

/// LoginScreen - Onboarding/Login screen
class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  bool _isLoginMode = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Only for registration

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (!_isLoginMode && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final apiService = ref.read(apiServiceProvider);
    
    try {
      if (_isLoginMode) {
        await apiService.login(email, password);
      } else {
        await apiService.register(name, email, password);
        // After registration, auto-login
        await apiService.login(email, password);
      }
      
      // Fetch initial data
      await ref.read(filesProvider.notifier).fetchFiles();
      await ref.read(notificationsProvider.notifier).fetchNotifications();
      
      widget.onLogin();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to ${_isLoginMode ? 'login' : 'register'}: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: Stack(
          children: [
            // Decorative clean line background
            Positioned.fill(
              child: CustomPaint(
                painter: DecorativeLinePainter(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        // Typography
                        _buildTitle(isDark)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms),
                        
                        const SizedBox(height: 40),
                        
                        // Form
                        _buildForm(isDark)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 200.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 200.ms),

                        const SizedBox(height: 32),
                        
                        // Call to Action
                        _buildCTA(isDark)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 300.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 300.ms),
                            
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Text(
      'Listen to\ndocuments\nanytime with\nPDF Audio',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w500,
        letterSpacing: -1.0,
        height: 0.95,
        color: isDark ? Colors.white : const Color(0xFF1C1C1E),
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildForm(bool isDark) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF8F9FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: TextStyle(
        color: AppColors.gray400,
        fontWeight: FontWeight.w500,
      ),
    );

    final textStyle = TextStyle(
      color: isDark ? Colors.white : const Color(0xFF1C1C1E),
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isLoginMode) ...[
          TextField(
            controller: _nameController,
            style: textStyle,
            decoration: inputDecoration.copyWith(
              hintText: 'Full Name',
              prefixIcon: Icon(LucideIcons.user, color: AppColors.gray400),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _emailController,
          style: textStyle,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration.copyWith(
            hintText: 'Email Address',
            prefixIcon: Icon(LucideIcons.mail, color: AppColors.gray400),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          style: textStyle,
          obscureText: true,
          decoration: inputDecoration.copyWith(
            hintText: 'Password',
            prefixIcon: Icon(LucideIcons.lock, color: AppColors.gray400),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleSubmit(),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                _isLoginMode = !_isLoginMode;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
            ),
            child: Text(
              _isLoginMode ? 'Create an account' : 'Already have an account? Login',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTA(bool isDark) {
    return Column(
      children: [
        AnimatedScaleButton(
          onTap: _isLoading ? null : _handleSubmit,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: BoxDecoration(
              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isLoading 
                      ? 'Please wait...' 
                      : (_isLoginMode ? 'Log In' : 'Sign Up'),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
                if (_isLoading)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  )
                else
                  Icon(
                    LucideIcons.arrowRight,
                    size: 24,
                    color: isDark ? Colors.black : Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// CustomPainter for decorative background lines
class DecorativeLinePainter extends CustomPainter {
  final Color color;

  DecorativeLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Line 1
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.25,
      size.width,
      size.height * 0.3,
    );

    // Line 2
    path.moveTo(0, size.height * 0.35);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width,
      size.height * 0.35,
    );

    // Line 3
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.35,
      size.width,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
