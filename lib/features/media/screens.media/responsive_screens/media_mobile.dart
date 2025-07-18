import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/media_content.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widgets/media_uploader.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MediaMobileScreen extends StatelessWidget {
  const MediaMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Breadcrumbs
                  const TBreadcrumbsWithHeading(
                    heading: 'Media',
                    breadcrumbItems: [TRoutes.login, 'Media Screen'],
                    returnToPrevioiusScreen: false,
                  ),
                ],
              ), // Row
              const SizedBox(height: TSizes.spaceBtwSections),
              const MediaUploader(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
