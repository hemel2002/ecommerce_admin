import 'package:ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/categories/controllers/category_controller.dart';
import 'package:ecommerce_admin_panel/utils/helpers/network_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecommerce_admin_panel/firebase_options.dart';
import 'app.dart';

/// Entry point of Flutter App
Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for full-screen mode
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize GetX Local Storage
  await GetStorage.init();

  // Initialize Network Manager
  Get.put(NetworkManager());

  // Initialize Firebase & Authentication Repository with duplicate app handling
  try {
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .then((value) {
      Get.put(AuthenticationRepository());

      // Initialize User Controller AFTER Firebase is ready
      Get.put(UserController());

      // Initialize Media Controller globally
      Get.put(MediaController());

      // Initialize Category Controller
      Get.put(CategoryController());
    });
  } catch (e) {
    // If Firebase is already initialized, continue
    if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized, continuing...');
      // Still initialize the controllers if Firebase is already ready
      Get.put(AuthenticationRepository());
      Get.put(UserController());
      Get.put(MediaController());
      Get.put(CategoryController());
    } else {
      debugPrint('Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Main App Starts here...
  runApp(App());
}
