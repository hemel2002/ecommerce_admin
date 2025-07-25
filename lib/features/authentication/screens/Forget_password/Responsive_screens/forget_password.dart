import 'package:ecommerce_admin_panel/common/widgets/login_signup/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    const MaterialAccentColor themeColor = Colors.deepPurpleAccent;
    final TextEditingController emailController = TextEditingController();

    final List<Widget> child = [
      // Logo or icon
      const SizedBox(height: 24),

      // Title
      Text(
        "Reset Password",
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 8),

      // Subtitle
      Text(
        "Enter your email to receive a reset link",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(height: 32),

      // Email field
      TextField(
        controller: emailController,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email Address',
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: themeColor, width: 1.5),
          ),
        ),
      ),
      const SizedBox(height: 24),

      // ...existing code...
      // Reset button
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/reset-password', parameters: {
              'email': emailController.text,
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: themeColor,
            elevation: 0,
          ),
          child: const Text(
            "Send Reset Link",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Back to login
      TextButton(
        onPressed: () => Get.back(),
        child: const Text(
          "Back to Login",
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];

    return login_signup_reset(
      size: size,
      children: child,
    );
  }
}
