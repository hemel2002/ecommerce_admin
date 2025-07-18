enum MediaCategory {
  banners,
  brands,
  categories,
  products,
  users,
  content,
  others;

  String get displayName {
    switch (this) {
      case MediaCategory.banners:
        return 'Banners';
      case MediaCategory.brands:
        return 'Brands';
      case MediaCategory.categories:
        return 'Categories';
      case MediaCategory.products:
        return 'Products';
      case MediaCategory.users:
        return 'Users';
      case MediaCategory.content:
        return 'Content';
      case MediaCategory.others:
        return 'Others';
    }
  }
}
