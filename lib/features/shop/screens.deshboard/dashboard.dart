import 'package:ecommerce_admin_panel/features/shop/screens.deshboard/responsive_screens/dashboard_mobile.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, we're using the mobile layout
    // You can add responsive logic here later for desktop/tablet layouts
    return const DashboardMobileScreen();
    // Scaffold(
    //     body: Padding(
    //       padding: const EdgeInsets.all(30),
    //       child: Center(
    //         child: Column(
    //           children: [
    //             // Search Field
    //             TextFormField(
    //               controller: controller.searchTextController,
    //               onChanged: (query) => controller.searchQuery(query),
    //               decoration: const InputDecoration(
    //                 hintText: 'Search',
    //                 prefixIcon: Icon(Iconsax.search_normal),
    //                 border: OutlineInputBorder(),
    //               ),
    //             ),

    //             const SizedBox(height: TSizes.spaceBtwSections),

    //             // Data Table
    //             Expanded(
    //               child: Obx(() {
    //                 return TPaginatedDataTable(
    //                   sortAscending: controller.sortAscending.value,
    //                   sortColumnIndex: controller.sortColumnIndex.value,
    //                   columns: [
    //                     const DataColumn(label: Text('Column 1')),
    //                     DataColumn(
    //                       label: const Text('Column 2'),
    //                       onSort: (columnIndex, ascending) =>
    //                           controller.sortById(columnIndex, ascending),
    //                     ),
    //                     const DataColumn(label: Text('Column 3')),
    //                     DataColumn(
    //                       label: const Text('Column 4'),
    //                       onSort: (columnIndex, ascending) =>
    //                           controller.sortById(columnIndex, ascending),
    //                     ),
    //                   ],
    //                   source: MyData(),
    //                 );
    //               }),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
  }
}

// class MyData extends DataTableSource {
//   final DashboardController controller = Get.put(DashboardController());

//   @override
//   DataRow2 getRow(int index) {
//     final data = controller.filteredDataList[index];

//     return DataRow2(
//       onTap: () {
//         print("Row ${index + 1} is Clicked");
//       },
//       selected: controller.selectedRows[index],
//       onSelectChanged: (value) =>
//           controller.selectedRows[index] = value ?? false,
//       cells: [
//         DataCell(Text(data['Column1'] ?? '')),
//         DataCell(Text(data['Column2'] ?? '')),
//         DataCell(Text(data['Column3'] ?? '')),
//         DataCell(Text(data['Column4'] ?? '')),
//       ],
//     ); // DataRow2
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => controller.filteredDataList.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class DashboardController extends GetxController {
//   // Observable data lists
//   var dataList = <Map<String, String>>[].obs;
//   var filteredDataList = <Map<String, String>>[].obs;

//   // Selection and sorting state
//   RxList<bool> selectedRows = <bool>[].obs;
//   RxInt sortColumnIndex = 1.obs;
//   RxBool sortAscending = true.obs;

//   // Search controller
//   final TextEditingController searchTextController = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchDummyData();
//   }

//   /// Fetches dummy data for the table
//   void fetchDummyData() {
//     dataList.assignAll(List.generate(
//       36,
//       (index) => {
//         'column1': 'Item ${index + 1}',
//         'column2': 'Description ${index + 1}',
//         'column3': 'Category ${(index % 3) + 1}',
//         'column4': 'Value ${index + 1}',
//       },
//     ));
//     filteredDataList.assignAll(dataList);
//     selectedRows.assignAll(List.filled(dataList.length, false));
//   }

//   /// Sorts the data by specified column
//   void sortById(int columnIndex, bool ascending) {
//     sortColumnIndex.value = columnIndex;
//     sortAscending.value = ascending;

//     filteredDataList.sort((a, b) {
//       final columnKey = 'column${columnIndex + 1}';
//       final aValue = a[columnKey]?.toLowerCase() ?? '';
//       final bValue = b[columnKey]?.toLowerCase() ?? '';

//       return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
//     });
//   }

//   /// Filters data based on search query
//   void searchQuery(String query) {
//     if (query.isEmpty) {
//       filteredDataList.assignAll(dataList);
//     } else {
//       filteredDataList.assignAll(dataList
//           .where((item) =>
//               item['column1']?.toLowerCase().contains(query.toLowerCase()) ??
//               false)
//           .toList());
//     }
//   }

//   @override
//   void onClose() {
//     searchTextController.dispose();
//     super.onClose();
//   }
// }
