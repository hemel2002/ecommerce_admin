import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:ecommerce_admin_panel/features/authentication/models/user_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/text_strings.dart';
import 'package:ecommerce_admin_panel/utils/helpers/network_manager.dart';
import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;
  final localStorage = GetStorage();

  // Controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Load saved credentials if remember me was checked
    final savedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD');
    if (savedEmail != null) {
      email.text = savedEmail;
      rememberMe.value = true;
    }
    if (savedPassword != null) {
      password.text = savedPassword;
    }
    super.onInit();
  }

  /// Toggle Remember Me checkbox
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> emailAndPasswordLogin() async {
    try {
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      // Check network connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // Debug: Print the credentials being used
      debugPrint('Attempting login with email: ${email.text.trim()}');

      // Remember Me - Save credentials if checked
      if (rememberMe.value) {
        await localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        await localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // Show loading indicator
      TFullScreenLoader.openLoadingDialog(
          'Logging in...', TImages.docerAnimation);

      // Login user using Email & Password Authentication
      debugPrint('Calling Firebase authentication...');
      final result =
          await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      debugPrint('Firebase authentication successful: ${result.user?.email}');

      // Fetch user details
      debugPrint('Fetching user details...');
      final userController = Get.put(UserController());
      var user = await userController.fetchUserDetails();
      debugPrint('User fetched: ${user.email}, role: ${user.role}');

      // Auto-promote hemel2002@gmail.com to admin if not already admin
      if (user.email.isEmpty || user.role != AppRole.admin) {
        final currentUser = AuthenticationRepository.instance.currentUser;
        if (currentUser?.email == 'hemel2002@gmail.com') {
          debugPrint('Auto-promoting hemel2002@gmail.com to admin...');
          await userController.promoteCurrentUserToAdmin();
          // Fetch user details again to get updated role
          user = await userController.fetchUserDetails();
          debugPrint('User updated: ${user.email}, role: ${user.role}');
        }
      }

      // If user is not admin, logout and show error
      if (user.role != AppRole.admin) {
        await AuthenticationRepository.instance.logout();
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Not Authorized',
          message:
              'You are not authorized or do not have access. Contact Admin.',
        );
        return;
      } else {
        // Stop loading and redirect to dashboard (not media directly)
        TFullScreenLoader.stopLoading();
        Get.offAllNamed(TRoutes.dashboard);
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      debugPrint('Login error: $e');
      TLoaders.errorSnackBar(title: 'Login Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerAdmin() async {
    try {
      // Check network connectivity first
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Creating Admin Account...', TImages.docerAnimation);

      debugPrint('Creating admin account with email: ${email.text.trim()}');

      // Register new admin user
      final credential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      debugPrint(
          'Admin account created successfully: ${credential.user?.email}');

      // Create user document in Firestore
      if (credential.user != null) {
        final userRepository = Get.put(UserRepository());
        await userRepository.createUser(
          UserModel(
            id: credential.user!.uid,
            firstName: 'Admin',
            lastName: 'User',
            email: email.text.trim(),
            userName: 'admin_user',
            phoneNumber: '',
            profilePicture: '',
            role: AppRole.admin,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        debugPrint('Admin user document created in Firestore');
      }

      // Stop loading and navigate
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Admin account created successfully! You can now login.',
      );

      // Clear form for login
      email.clear();
      password.clear();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      debugPrint('Admin registration error: $e');
      TLoaders.errorSnackBar(
        title: 'Registration Failed',
        message: e.toString(),
      );
    }
  }

  /// Create admin user if the current user exists but doesn't have admin role
  Future<void> upgradeToAdmin() async {
    try {
      final currentUser = AuthenticationRepository.instance.currentUser;
      if (currentUser == null) {
        TLoaders.errorSnackBar(
          title: 'No User',
          message: 'Please login first.',
        );
        return;
      }

      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Upgrading to Admin...', TImages.docerAnimation);

      debugPrint('Upgrading user to admin: ${currentUser.email}');

      // Create/Update user document in Firestore with admin role
      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(
        UserModel(
          id: currentUser.uid,
          firstName: 'Admin',
          lastName: 'User',
          email: currentUser.email ?? '',
          userName: 'admin_user',
          phoneNumber: '',
          profilePicture: '',
          role: AppRole.admin,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      debugPrint('User upgraded to admin successfully');

      // Stop loading and redirect
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: 'Success',
        message: 'User upgraded to admin successfully!',
      );

      // Now try to login again
      await emailAndPasswordLogin();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      debugPrint('Admin upgrade error: $e');
      TLoaders.errorSnackBar(
        title: 'Upgrade Failed',
        message: e.toString(),
      );
    }
  }

  /// Quick method to create admin user with default credentials
  Future<void> createDefaultAdmin() async {
    try {
      // Set default admin credentials
      email.text = TTexts.adminEmail;
      password.text = TTexts.adminPassword;

      // Call register admin
      await registerAdmin();
    } catch (e) {
      debugPrint('Error creating default admin: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to create default admin: ${e.toString()}',
      );
    }
  }

  /// One-click solution to create admin user with default credentials
  Future<void> createAdminNow() async {
    try {
      // Use default admin credentials from TTexts
      const adminEmail = TTexts.adminEmail;
      const adminPassword = TTexts.adminPassword;

      debugPrint('Creating admin user: $adminEmail');

      // Check network connectivity first
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Creating Admin Account...', TImages.docerAnimation);

      // Register new admin user in Firebase Auth
      final credential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(adminEmail, adminPassword);

      debugPrint('Admin created in Firebase Auth: ${credential.user?.email}');

      // Create admin user document in Firestore
      if (credential.user != null) {
        final userRepository = Get.put(UserRepository());
        await userRepository.createUser(
          UserModel(
            id: credential.user!.uid,
            firstName: 'Admin',
            lastName: 'User',
            email: adminEmail,
            userName: 'admin_user',
            phoneNumber: '',
            profilePicture: '',
            role: AppRole.admin,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        debugPrint('Admin user document created in Firestore');
      }

      // Stop loading
      TFullScreenLoader.stopLoading();

      // Show success message
      TLoaders.successSnackBar(
        title: 'Success!',
        message: 'Admin account created successfully! You can now login.',
      );

      // Pre-fill the form with admin credentials
      email.text = adminEmail;
      password.text = adminPassword;
    } catch (e) {
      TFullScreenLoader.stopLoading();
      debugPrint('Admin creation error: $e');

      // If user already exists, try to upgrade instead
      if (e.toString().contains('email-already-in-use')) {
        TLoaders.warningSnackBar(
          title: 'User Exists',
          message:
              'User already exists. Try clicking "Upgrade to Admin" instead.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Creation Failed',
          message: e.toString(),
        );
      }
    }
  }
}
