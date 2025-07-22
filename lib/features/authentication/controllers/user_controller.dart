import 'package:ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:ecommerce_admin_panel/features/authentication/models/user_model.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final RxBool loading = false.obs;
  final Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    // Don't fetch user details during init to avoid context issues
    // fetchUserDetails will be called later when needed
    super.onInit();
  }

  /// Fetches user details from the repository
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();

      this.user.value = user;
      loading.value = false;
      return user;
    } catch (e) {
      loading.value = false;
      user.value = UserModel.empty();
      TLoaders.errorSnackBar(
          title: 'Something went wrong.', message: e.toString());
      return UserModel.empty();
    } finally {
      loading.value = false;
    }
  }

  /// Promote current user to admin
  Future<void> promoteCurrentUserToAdmin() async {
    try {
      loading.value = true;
      final currentUser = AuthenticationRepository.instance.currentUser;
      if (currentUser != null) {
        await userRepository.createOrUpdateUserAsAdmin(currentUser.email ?? '');
        // Refresh user data
        await fetchUserDetails();
        TLoaders.successSnackBar(
          title: 'Success',
          message: 'User promoted to admin successfully',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to promote user: ${e.toString()}',
      );
    } finally {
      loading.value = false;
    }
  }
}
