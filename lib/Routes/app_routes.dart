import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/middleware/auth_middleware.dart';
import 'package:ecommerce_admin_panel/features/authentication/screens/Reset_password/Responsive_screens/reset_password.dart';
import 'package:ecommerce_admin_panel/features/authentication/screens/Forget_password/Responsive_screens/forget_password.dart';
import 'package:ecommerce_admin_panel/features/authentication/screens/login/login.dart';
import 'package:ecommerce_admin_panel/features/categories/screens.category/responsive_screens/category/all_categories/categories.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/media_screen.dart';
import 'package:ecommerce_admin_panel/features/categories/screens.category/responsive_screens/category/all_categories/createCategories.dart';
import 'package:ecommerce_admin_panel/features/categories/editCategories.dart';
import 'package:ecommerce_admin_panel/features/products/products.dart';
import 'package:ecommerce_admin_panel/features/products/create_products.dart';
import 'package:ecommerce_admin_panel/features/shop/screens.deshboard/dashboard.dart';
import 'package:get/get.dart';

class TApproute {
  static final List<GetPage> pages = [
    // Public routes (no authentication required)
    GetPage(name: TRoutes.login, page: () => AdminLoginScreen()),
    GetPage(name: TRoutes.forgotPassword, page: () => const ForgetScreen()),
    GetPage(name: TRoutes.resetPassword, page: () => const ResetScreen()),

    // Protected routes (authentication required)
    GetPage(
      name: TRoutes.categories,
      page: () => const CategoriesScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: TRoutes.dashboard,
      page: () => const DashboardScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: TRoutes.media,
      page: () => const MediaScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: TRoutes.products,
      page: () => const ProductsScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: TRoutes.createCategory,
      page: () => const CreateCategoryScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: TRoutes.editCategory,
      page: () => const EditCategoryScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: TRoutes.createProduct,
      page: () => const CreateProductDesktopScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
