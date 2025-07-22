import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/utils/formatters/formatter.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/foundation.dart';

/// Model class representing user data.
class UserModel {
  final String? id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;

  /// Constructor for UserModel.
  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  // Getter for formatted creation date
  String get formattedDate => TFormatter.formatDate(createdAt);

  // Getter for formatted update date
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  // Getter for formatted phone number
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);
  // Add fromJson and toJson methods for serialization
  static UserModel empty() {
    return UserModel(email: '');
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      debugPrint('DEBUG: Raw Firestore data: $data');
      debugPrint('DEBUG: Document ID: ${document.id}');

      final firstName = data['firstName'] as String? ?? '';
      final lastName = data['lastName'] as String? ?? '';
      final userName = data['userName'] as String? ?? '';
      final email = data['email'] as String? ?? '';
      final phoneNumber = data['phoneNumber'] as String? ?? '';
      final profilePicture = data['profilePicture'] as String? ?? '';
      final roleData = data['role'];

      debugPrint(
          'DEBUG: Extracted fields - firstName: $firstName, lastName: $lastName, email: $email, roleData: $roleData');

      final role =
          data.containsKey('role') ? _parseRole(data['role']) : AppRole.user;

      debugPrint('DEBUG: Final parsed role: $role');

      return UserModel(
        id: document.id,
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
        role: role,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt:
            (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } else {
      debugPrint('DEBUG: Document data is null, returning empty user');
      return UserModel.empty();
    }
  }

  /// Parse role from Firestore data with debug logging
  static AppRole _parseRole(dynamic roleData) {
    if (roleData == null) {
      print('DEBUG: Role data is null, defaulting to user');
      return AppRole.user;
    }

    final roleString = roleData.toString().toLowerCase().trim();
    print('DEBUG: Parsing role from Firestore: "$roleString"');
    print('DEBUG: Expected admin name: "${AppRole.admin.name.toLowerCase()}"');
    print('DEBUG: Expected user name: "${AppRole.user.name.toLowerCase()}"');

    if (roleString == AppRole.admin.name.toLowerCase()) {
      print('DEBUG: Role matched admin');
      return AppRole.admin;
    } else if (roleString == AppRole.user.name.toLowerCase()) {
      print('DEBUG: Role matched user');
      return AppRole.user;
    } else {
      print(
          'DEBUG: Role "$roleString" did not match any enum, defaulting to user');
      return AppRole.user;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'role': role.toString().split('.').last,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
