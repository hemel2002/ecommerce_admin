import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/utils/formatters/formatter.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';

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
      return UserModel(
        id: document.id,
        firstName: data['firstName'] as String? ?? '',
        lastName: data['lastName'] as String? ?? '',
        userName: data['userName'] as String? ?? '',
        email: data['email'] as String? ?? '',
        phoneNumber: data['phoneNumber'] as String? ?? '',
        profilePicture: data['profilePicture'] as String? ?? '',
        role: data.containsKey('role')
            ? (data['role']?.toString().toLowerCase() ==
                    AppRole.admin.name.toLowerCase()
                ? AppRole.admin
                : AppRole.user)
            : AppRole.user,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt:
            (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } else {
      return UserModel.empty();
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
