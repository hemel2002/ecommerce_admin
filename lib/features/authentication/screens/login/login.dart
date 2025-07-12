import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/login_signup/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class AdminLoginScreen extends StatelessWidget {
  AdminLoginScreen({Key? key}) : super(key: key);

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool isHovering = false.obs;
  final MaterialAccentColor themeColor = Colors.deepPurpleAccent;

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        borderRadius: 12,
        animationDuration: const Duration(milliseconds: 300),
      );
    } else {
      isLoading.value = true;
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.snackbar(
          'Success',
          'Logged in successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          borderRadius: 12,
          animationDuration: const Duration(milliseconds: 300),
        );
        // Navigate to Admin Dashboard
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<Widget> child = [
      Text("Sign In",
          style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
      const SizedBox(height: 28),

      // Email Field
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

      const SizedBox(height: 20),

      // Password Field
      Obx(() => TextField(
            controller: passwordController,
            obscureText: !isPasswordVisible.value,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () =>
                    isPasswordVisible.value = !isPasswordVisible.value,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: themeColor, width: 1.5),
              ),
            ),
          )),

      const SizedBox(height: 24),

      // Login Button
      Obx(
        () => MouseRegion(
          onEnter: (_) => isHovering.value = true,
          onExit: (_) => isHovering.value = false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: isHovering.value
                  ? [
                      BoxShadow(
                        color: themeColor.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(56),
                elevation: 0,
              ),
              onPressed: isLoading.value ? null : login,
              child: isLoading.value
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text("Login",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      // Forgot Password
      TextButton(
        onPressed: () {
          Get.toNamed(TRoutes.forgotPassword);
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          "Forgot Password?",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ),
    ];

    return login_signup_reset(
      children: child,
      size: size,
    );
  }
}
