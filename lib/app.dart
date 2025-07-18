import 'package:ecommerce_admin_panel/Routes/app_routes.dart';
import 'package:ecommerce_admin_panel/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/headers/header.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/sidebars/sidebar.dart';

import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  App({super.key});
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  static final Uri _productUri =
      Uri.parse('https://codingwitht.com/ecommerce-app-with-admin-panel/');

  Future<void> _openProductPage() async {
    // On web this will open a new tab automatically
    if (!await launchUrl(_productUri, webOnlyWindowName: '_blank')) {
      debugPrint('Could not launch $_productUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: Scaffold(
        key: scaffoldkey,
        drawer: TSidebar(),
        backgroundColor: TColors.primary,
        appBar: THeader(
          scaffoldKey: scaffoldkey,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hey there',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _openProductPage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              color: TColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Get the Full E-Commerce App',
                            style: TextStyle(
                              color: TColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      getPages: TApproute.pages,
      initialRoute: TRoutes.categories,
    );
  }
}
