import 'package:ecommerce_admin_panel/Routes/app_routes.dart';
import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/features/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      getPages: TApproute.pages,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => AdminLoginScreen(), // Redirect unknown routes to login
      ),
      initialRoute:
          TRoutes.login, // Changed to login first, then navigate to categories
    );
  }
}
