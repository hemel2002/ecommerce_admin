import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/login_signup/style.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.parameters['email'] ?? '';
    const MaterialAccentColor themeColor = Colors.deepPurpleAccent;

    final List<Widget> child = [
      /// Header
      Row(
        children: [
          IconButton(
            onPressed: () => Get.offAllNamed(TRoutes.login),
            icon: const Icon(CupertinoIcons.clear, color: themeColor),
          ),
        ],
      ),
      const SizedBox(height: TSizes.spaceBtwItems),

      /// Image
      const Image(
          image: AssetImage(TImages.deliveredEmailIllustration),
          width: 300,
          height: 300),
      const SizedBox(height: TSizes.spaceBtwItems),

      /// Title & SubTitle
      Text(
        TTexts.changeYourPasswordTitle,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),

      const SizedBox(height: TSizes.spaceBtwItems),

      Text(
        email,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
      ),
      const SizedBox(height: TSizes.spaceBtwItems),

      Text(
        TTexts.changeYourPasswordSubTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
      ),
      const SizedBox(height: TSizes.spaceBtwSections),

      /// Buttons
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
          ),
          onPressed: () => Get.offAllNamed(TRoutes.login),
          child: const Text(TTexts.done),
        ),
      ),
      const SizedBox(height: TSizes.spaceBtwItems),
      SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.deepPurple.withOpacity(0.1);
                }
                return Colors.transparent;
              },
            ),
            overlayColor: WidgetStateProperty.all(
              Colors.deepPurple.withOpacity(0.2),
            ),
            side: WidgetStateProperty.resolveWith<BorderSide?>(
              (states) {
                if (states.contains(WidgetState.hovered)) {
                  return const BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2,
                  );
                }
                return BorderSide.none;
              },
            ),
          ),
          child: const Text(
            TTexts.resendEmail,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ];

    final size = MediaQuery.of(context).size;
    return login_signup_reset(size: size, children: child);
  }
}
