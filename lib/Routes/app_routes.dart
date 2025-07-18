import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/Routes/routes_middleware.dart';
import 'package:ecommerce_admin_panel/features/authentication/screens/Reset_password/Responsive_screens/reset_password.dart';
import 'package:ecommerce_admin_panel/features/authentication/screens/Forget_password/Responsive_screens/forget_password.dart';
import 'package:ecommerce_admin_panel/features/authentication/screens/login/login.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/categories.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/dashboard.dart';
import 'package:get/get.dart';

class TApproute {
  static final List<GetPage> pages = [
    // Add your app routes here
    // Example:
    // GetPage(name: TRoutes.home, page: () => HomeScreen()),
    GetPage(name: TRoutes.login, page: () => AdminLoginScreen()),
    GetPage(name: TRoutes.forgotPassword, page: () => ForgetScreen()),
    GetPage(name: TRoutes.resetPassword, page: () => ResetScreen()),
    GetPage(name: TRoutes.categories, page: () => const CategoriesScreen()),
    GetPage(
        name: TRoutes.dashboard,
        page: () => const DashboardScreen(),
        middlewares: [TRouteMiddleware()]),
  ];
}
