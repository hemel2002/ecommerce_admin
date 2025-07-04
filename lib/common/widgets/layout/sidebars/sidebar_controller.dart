import 'package:get/get.dart';

class SidebarController extends GetxController {
  final RxString _activeItem = ''.obs;
  final RxString _hoverItem = ''.obs;

  void menuOnTap(String route) {
    _activeItem.value = route;
    Get.toNamed(route);
  }

  void changeHoverItem(String item) {
    _hoverItem.value = item;
  }

  bool isActive(String item) => _activeItem.value == item;
  bool isHover(String item) => _hoverItem.value == item;
}
