# DashboardLayout Implementation Guide

## Overview

The `DashboardLayout` widget provides a consistent layout with header and sidebar navigation for all admin screens in your ecommerce admin panel.

## Features

- ✅ **Header with Navigation**: Menu button, search, notifications, user avatar
- ✅ **Side Navigation Drawer**: Consistent navigation menu
- ✅ **Responsive Design**: Works on mobile, tablet, and desktop
- ✅ **Reusable Component**: Use across all admin screens
- ✅ **Flexible Content**: Accepts any widget as body content

## Usage

### Basic Implementation

```dart
import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';

class YourScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      body: YourScreenContent(),
    );
  }
}
```

### With Optional Parameters

```dart
DashboardLayout(
  body: YourScreenContent(),
  title: "Custom Title",                    // Optional custom title
  floatingActionButton: FloatingActionButton( // Optional FAB
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)
```

## Updated Screens

### ✅ Already Updated:

1. **DashboardMobileScreen** - Uses DashboardLayout
2. **CategoriesScreen** - Uses DashboardLayout
3. **DashboardScreen** - Routes to DashboardMobileScreen

### 🔄 To Update Your Other Screens:

#### Replace this pattern:

```dart
class YourScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YourContent(),
    );
  }
}
```

#### With this pattern:

```dart
import 'package:ecommerce_admin_panel/common/widgets/layout/dashboard_layout.dart';

class YourScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      body: YourContent(),
    );
  }
}
```

## Screen Categories

### ✅ Use DashboardLayout for:

- Dashboard screens
- Product management screens
- Category management screens
- User management screens
- Order management screens
- Settings screens
- Any admin panel screen that needs navigation

### ❌ Don't use DashboardLayout for:

- Login/Authentication screens
- Splash screens
- Error screens
- Full-screen modal dialogs

## File Structure

```
lib/
├── common/widgets/layout/
│   ├── dashboard_layout.dart          # Main layout widget
│   ├── headers/header.dart           # Header component
│   └── sidebars/sidebar.dart         # Sidebar component
└── features/shop/screens/
    ├── dashboard/                    # ✅ Updated
    ├── category/                     # ✅ Updated
    └── example_admin_screen.dart     # ✅ Example template
```

## Benefits

1. **Consistency**: Same navigation experience across all screens
2. **Maintainability**: Update header/sidebar in one place
3. **Clean Code**: No need to repeat scaffold setup
4. **Responsive**: Automatic mobile/desktop adaptation
5. **Extensible**: Easy to add new features to all screens

## Next Steps

1. Update your existing admin screens to use `DashboardLayout`
2. Use the `example_admin_screen.dart` as a template for new screens
3. Customize the layout properties as needed for each screen
