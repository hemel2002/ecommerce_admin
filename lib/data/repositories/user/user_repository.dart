import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/features/authentication/models/user_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../authentication/authentication_repository.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserModel> fetchAdminDetails() async {
    try {
      final currentUser = AuthenticationRepository.instance.currentUser;
      debugPrint('DEBUG: Current user UID: ${currentUser?.uid}');
      debugPrint('DEBUG: Current user email: ${currentUser?.email}');

      final docSnapshot =
          await _db.collection('users').doc(currentUser!.uid).get();

      debugPrint('DEBUG: Document exists: ${docSnapshot.exists}');
      if (docSnapshot.exists) {
        debugPrint('DEBUG: Document data: ${docSnapshot.data()}');
        final user = UserModel.fromSnapshot(docSnapshot);
        debugPrint(
            'DEBUG: Parsed user - Email: ${user.email}, Role: ${user.role}');
        return user;
      } else {
        debugPrint('DEBUG: No document found, returning empty user');
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('DEBUG: FirebaseAuthException: ${e.message}');
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      debugPrint('DEBUG: FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      debugPrint('DEBUG: FormatException');
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      debugPrint('DEBUG: PlatformException: ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      debugPrint('DEBUG: General exception: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).update(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update specific field in user document
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection('users')
          .doc(AuthenticationRepository.instance.currentUser!.uid)
          .update(json);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Create or update user to admin role
  Future<void> createOrUpdateUserAsAdmin(String email) async {
    try {
      final currentUser = AuthenticationRepository.instance.currentUser;
      if (currentUser == null) return;

      // Create admin user data
      final adminUser = UserModel(
        id: currentUser.uid,
        email: email,
        firstName: '', // You can update these later
        lastName: '',
        userName: email.split('@').first,
        role: AppRole.admin,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Use set with merge to create or update
      await _db.collection('users').doc(currentUser.uid).set(
            adminUser.toJson(),
            SetOptions(merge: true),
          );
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Add your user-related methods here
}
