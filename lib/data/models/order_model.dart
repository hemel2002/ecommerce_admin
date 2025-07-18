import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final String docId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final DateTime? deliveryDate;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.deliveryDate,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipment on the way';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  /// Static function to create an empty user model
  static OrderModel empty() => OrderModel(
        id: '',
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
        totalAmount: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'docId': docId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'deliveryDate': deliveryDate?.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      docId: json['docId'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      orderDate: DateTime.parse(json['orderDate']),
      paymentMethod: json['paymentMethod'] ?? 'Paypal',
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
    );
  }
}
