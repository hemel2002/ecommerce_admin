import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TBreadcrumbsWithHeading extends StatelessWidget {
  const TBreadcrumbsWithHeading({
    super.key,
    required this.heading,
    required this.breadcrumbItems,
    required this.returnToPrevioiusScreen,
  });

  final String heading;
  final List<String> breadcrumbItems;
  final bool returnToPrevioiusScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // breadcrumbs trail
        Row(
          children: [
            InkWell(
              onTap: () => Get.offAllNamed(TRoutes.dashboard),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.xs),
                child: Text(
                  'Dashboard',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(fontWeightDelta: -1),
                ),
              ),
            ),
            for (int i = 0; i < breadcrumbItems.length; i++)
              Row(
                children: [
                  const Text('/'),
                  InkWell(
                    onTap: i == breadcrumbItems.length - 1
                        ? null
                        : () => Get.toNamed(breadcrumbItems[i]),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.xs),
                      child: Text(
                        i == breadcrumbItems.length - 1
                            ? capitalize(breadcrumbItems[i])
                            : capitalize(breadcrumbItems[i].substring(1)),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(fontWeightDelta: -1),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: TSizes.fontSizeSm),
      ],
    );
  }

  String capitalize(String s) {
    return s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
  }
}
