import 'package:ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final Controller = UserController.instance;
    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(
          bottom: BorderSide(color: TColors.grey, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md, vertical: TSizes.md),
      child: AppBar(
        leading: IconButton(
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Iconsax.menu, color: TColors.primary, size: 24)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.search_normal,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.notification5,
            ),
          ),
          const SizedBox(
            width: (TSizes.spaceBtwItems / 2),
          ),
          Obx(
            () => Row(
              children: [
                Controller.loading.value
                    ? const TShimmerEffect(width: 40, height: 40)
                    : TRoundedImage(
                        imageType:
                            Controller.user.value.profilePicture.isNotEmpty
                                ? ImageType.network
                                : ImageType.asset,
                        image: Controller.user.value.profilePicture.isNotEmpty
                            ? Controller.user.value.profilePicture
                            : TImages.user,
                        height: 40,
                        width: 40,
                        padding: 2,
                      ),
                const SizedBox(
                  width: TSizes.spaceBtwItems,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
