import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/categories.dart';
import 'package:get/get.dart';

import 'routes.dart';

class TAppRoute {
  static final List<GetPage> pages = [
    // Categories
    GetPage(
      name: TRoutes.categories,
      page: () => const CategoriesScreen(),
    )
    // middlewares: [TRoutesMiddleware()]),
    //GetPage(name: TRoutes.createCategory, page: () => const CreateCategoryScreen(), middlewares: [TRouteMiddleware()]),
    //GetPage(name: TRoutes.editCategory, page: () => const EditCategoryScreen(), middlewares: [TRouteMiddleware()]),
  ];
}
