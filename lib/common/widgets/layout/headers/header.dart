import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: TColors.white,
        border: Border(
          bottom: BorderSide(color: TColors.grey, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.md),
      child: AppBar(
        leading: IconButton(
            onPressed: () => scaffoldKey?.currentState?.openDrawer(),
            icon: Icon(Iconsax.menu, color: TColors.primary, size: 24)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.search_normal,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.notification5,
            ),
          ),
          SizedBox(
            width: (TSizes.spaceBtwItems / 2),
          ),
          Row(
            children: [
              TRoundedImage(
                imageType: ImageType.asset,
                image: TImages.user,
                height: 40,
                width: 40,
                padding: 2,
              ),
              SizedBox(
                width: TSizes.spaceBtwItems,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
