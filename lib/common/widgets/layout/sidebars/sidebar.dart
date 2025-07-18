import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/sidebars/sidebar_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280, // Fixed width for consistency
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: TColors.white,
          border: Border(
            right: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 16),
              // Logo and App Name
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    TCircularImage(
                      height: 40,
                      width: 40,
                      image: TImages.darkAppLogo,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections * 1.5),

              // Menu Section
              _buildMenuSection(context, "MENU", [
                MenuWidget(
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  route: TRoutes.dashboard,
                ),
                MenuWidget(
                  icon: Icons.shopping_cart_outlined,
                  title: "Products",
                  route: TRoutes.products,
                ),
                MenuWidget(
                  icon: Icons.category_outlined,
                  title: "Categories",
                  route: TRoutes.categories,
                ),
                MenuWidget(
                  icon: Icons.perm_media_outlined,
                  title: "Media",
                  route: TRoutes.media,
                ),
                MenuWidget(
                  icon: Icons.people_outline,
                  title: "Customers",
                  route: TRoutes.customers ?? '/customers',
                ),
                MenuWidget(
                  icon: Icons.receipt_long_outlined,
                  title: "Orders",
                  route: TRoutes.orders ?? '/orders',
                ),
                MenuWidget(
                  icon: Icons.analytics_outlined,
                  title: "Analytics",
                  route: TRoutes.analytics ?? '/analytics',
                ),
              ]),

              const SizedBox(height: TSizes.spaceBtwSections),

              // System Section
              _buildMenuSection(context, "SYSTEM", [
                MenuWidget(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  route: TRoutes.settings,
                ),
                MenuWidget(
                  icon: Icons.logout_outlined,
                  title: "Logout",
                  route: '/logout',
                  isLogout: true,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, String title, List<MenuWidget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey.shade600,
                  letterSpacing: 1.2,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),

        // Menu Items
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    required this.icon,
    required this.title,
    required this.route,
    this.isLogout = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String route;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());

    return Obx(
      () {
        final isActive = menuController.isActive(route);
        final isHovered = menuController.isHover(route);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                if (isLogout) {
                  _showLogoutDialog(context);
                } else {
                  menuController.menuOnTap(route);
                }
              },
              onHover: (isHover) => isHover
                  ? menuController.changeHoverItem(route)
                  : menuController.changeHoverItem(''),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: isActive
                      ? TColors.primary.withOpacity(0.1)
                      : isHovered
                          ? Colors.grey.shade100
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isActive
                      ? Border.all(color: TColors.primary, width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isActive
                          ? TColors.primary
                          : isHovered
                              ? TColors.primary
                              : Colors.grey.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isActive
                                  ? TColors.primary
                                  : isHovered
                                      ? TColors.primary
                                      : Colors.grey.shade800,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w500,
                            ),
                      ),
                    ),
                    if (isActive)
                      Icon(
                        Icons.chevron_right,
                        color: TColors.primary,
                        size: 16,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text(
              'Are you sure you want to logout from the admin panel?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAllNamed('/login');
              },
              style: TextButton.styleFrom(
                foregroundColor: TColors.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
