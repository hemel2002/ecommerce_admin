import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/login_signup/style.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/login_controller.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class AdminLoginScreen extends StatelessWidget {
  AdminLoginScreen({Key? key}) : super(key: key);

  final RxBool isHovering = false.obs;
  final MaterialAccentColor themeColor = Colors.deepPurpleAccent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final LoginController controller = Get.put(LoginController());
    final List<Widget> child = [
      Text("Sign In",
          style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
      const SizedBox(height: 28),

      // Form wrapper with key
      Form(
        key: controller.loginFormKey,
        child: Column(
          children: [
            // Email Field
            TextFormField(
              controller: controller.email,
              validator: TValidator.validateEmail,
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
                prefixIcon:
                    const Icon(Icons.email_outlined, color: Colors.white70),
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
            Obx(() => TextFormField(
                  controller: controller.password,
                  validator: (value) =>
                      TValidator.validateEmptyText('password', value),
                  obscureText: controller.hidePassword.value,
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.hidePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: themeColor, width: 1.5),
                    ),
                  ),
                )),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Remember Me Checkbox
      Obx(() => Row(
            children: [
              Checkbox(
                value: controller.rememberMe.value,
                onChanged: controller.toggleRememberMe,
                activeColor: themeColor,
                checkColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              Text(
                'Remember Me',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          )),

      const SizedBox(height: 16),

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
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.emailAndPasswordLogin(),
              child: controller.isLoading.value
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
