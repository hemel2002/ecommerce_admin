import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class login_signup_reset extends StatelessWidget {
  const login_signup_reset({
    super.key,
    required this.size,
    required this.children,
  });

  final MaterialAccentColor themeColor = Colors.deepPurpleAccent;
  final Size size;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              // Background with gradient overlay
              Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7),
                    BlendMode.darken,
                  ),
                ),
              ),

              // Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title
                      Column(
                        children: [
                          Icon(Icons.admin_panel_settings,
                              size: 60, color: themeColor),
                          const SizedBox(height: 16),
                          Text("Admin Portal",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              )),
                          const SizedBox(height: 8),
                          Text("Secure access to dashboard",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              )),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Login Card
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: size.width > 600 ? 500 : size.width * 0.9,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.deepPurpleAccent.withOpacity(1),
                              width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.6),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Footer
                      Text("v1.0.0",
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
