import 'package:ecommerce_admin_panel/data/models/order_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  // -- Orders
  static final List<OrderModel> orders = [
    // Monday - Multiple orders
    OrderModel(
      id: 'CNT0012',
      status: OrderStatus.processing,
      totalAmount: 265,
      orderDate: DateTime(2025, 7, 14), // Monday
      deliveryDate: DateTime(2025, 7, 14),
    ),
    OrderModel(
      id: 'CNT0013',
      status: OrderStatus.delivered,
      totalAmount: 180,
      orderDate: DateTime(2025, 7, 14), // Monday
      deliveryDate: DateTime(2025, 7, 14),
    ),

    // Tuesday - High sales day
    OrderModel(
      id: 'CNT0025',
      status: OrderStatus.shipped,
      totalAmount: 369,
      orderDate: DateTime(2025, 7, 15), // Tuesday
      deliveryDate: DateTime(2025, 7, 15),
    ),
    OrderModel(
      id: 'CNT0026',
      status: OrderStatus.processing,
      totalAmount: 295,
      orderDate: DateTime(2025, 7, 15), // Tuesday
      deliveryDate: DateTime(2025, 7, 15),
    ),
    OrderModel(
      id: 'CNT0027',
      status: OrderStatus.delivered,
      totalAmount: 156,
      orderDate: DateTime(2025, 7, 15), // Tuesday
      deliveryDate: DateTime(2025, 7, 15),
    ),

    // Wednesday - Medium sales
    OrderModel(
      id: 'CNT0152',
      status: OrderStatus.delivered,
      totalAmount: 254,
      orderDate: DateTime(2025, 7, 16), // Wednesday
      deliveryDate: DateTime(2025, 7, 16),
    ),
    OrderModel(
      id: 'CNT0153',
      status: OrderStatus.shipped,
      totalAmount: 320,
      orderDate: DateTime(2025, 7, 16), // Wednesday
      deliveryDate: DateTime(2025, 7, 16),
    ),

    // Thursday - Peak sales day
    OrderModel(
      id: 'CNT0205',
      status: OrderStatus.delivered,
      totalAmount: 355,
      orderDate: DateTime(2025, 7, 17), // Thursday
      deliveryDate: DateTime(2025, 7, 17),
    ),
    OrderModel(
      id: 'CNT0206',
      status: OrderStatus.pending,
      totalAmount: 420,
      orderDate: DateTime(2025, 7, 17), // Thursday
      deliveryDate: DateTime(2025, 7, 17),
    ),
    OrderModel(
      id: 'CNT0207',
      status: OrderStatus.processing,
      totalAmount: 285,
      orderDate: DateTime(2025, 7, 17), // Thursday
      deliveryDate: DateTime(2025, 7, 17),
    ),
    OrderModel(
      id: 'CNT0208',
      status: OrderStatus.delivered,
      totalAmount: 190,
      orderDate: DateTime(2025, 7, 17), // Thursday
      deliveryDate: DateTime(2025, 7, 17),
    ),

    // Friday - Current day
    OrderModel(
      id: 'CNT0300',
      status: OrderStatus.pending,
      totalAmount: 480,
      orderDate: DateTime(2025, 7, 18), // Friday
      deliveryDate: DateTime(2025, 7, 18),
    ),
    OrderModel(
      id: 'CNT0301',
      status: OrderStatus.processing,
      totalAmount: 165,
      orderDate: DateTime(2025, 7, 18), // Friday
      deliveryDate: DateTime(2025, 7, 18),
    ),

    // Saturday - Weekend orders
    OrderModel(
      id: 'CNT0400',
      status: OrderStatus.shipped,
      totalAmount: 225,
      orderDate: DateTime(2025, 7, 19), // Saturday
      deliveryDate: DateTime(2025, 7, 19),
    ),
    OrderModel(
      id: 'CNT0401',
      status: OrderStatus.delivered,
      totalAmount: 340,
      orderDate: DateTime(2025, 7, 19), // Saturday
      deliveryDate: DateTime(2025, 7, 19),
    ),

    // Sunday - Light sales day
    OrderModel(
      id: 'CNT0500',
      status: OrderStatus.pending,
      totalAmount: 125,
      orderDate: DateTime(2025, 7, 20), // Sunday
      deliveryDate: DateTime(2025, 7, 20),
    ),
  ];
  @override
  void onInit() {
    super.onInit();
    _calculateWeeklySales();
    _calculateOrderStatusData();
  }

  void _calculateWeeklySales() {
    // Reset weeklySales to zeros
    weeklySales.value = List<double>.filled(7, 0.0);

    final now = DateTime.now();
    final currentWeekStart = THelperFunctions.getStartOfWeek(now);
    final currentWeekEnd = currentWeekStart.add(const Duration(days: 7));

    for (var order in orders) {
      // Check if the order is within the current week
      if (order.orderDate
              .isAfter(currentWeekStart.subtract(const Duration(seconds: 1))) &&
          order.orderDate.isBefore(currentWeekEnd)) {
        // Calculate the day index (0 = Monday, 6 = Sunday)
        int index = order.orderDate.weekday - 1;

        // Add the order amount to the corresponding day
        weeklySales[index] += order.totalAmount;
      }
    }
  }

  void _calculateOrderStatusData() {
    // Clear existing data
    orderStatusData.clear();
    totalAmounts.clear();

    // Count orders by status and calculate total amounts
    for (var order in orders) {
      // Count orders
      orderStatusData[order.status] = (orderStatusData[order.status] ?? 0) + 1;

      // Sum total amounts
      totalAmounts[order.status] =
          (totalAmounts[order.status] ?? 0.0) + order.totalAmount;
    }
  }

  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

// Calculate weekly sales
