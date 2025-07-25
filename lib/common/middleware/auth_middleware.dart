import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Allow access to login and password reset pages without authentication
    if (route == TRoutes.login ||
        route == TRoutes.forgotPassword ||
        route == TRoutes.resetPassword) {
      return null;
    }

    // Check if user is authenticated
    final authRepo = Get.find<AuthenticationRepository>();
    if (authRepo.isAuthenticated()) {
      debugPrint(
          'AuthMiddleware: User is authenticated, allowing access to $route');
      return null; // Allow access
    } else {
      debugPrint(
          'AuthMiddleware: User not authenticated, redirecting to login');
      return const RouteSettings(name: TRoutes.login);
    }
  }
}
