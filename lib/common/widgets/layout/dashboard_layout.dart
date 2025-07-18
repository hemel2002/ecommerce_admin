import 'package:ecommerce_admin_panel/common/widgets/layout/headers/header.dart';
import 'package:ecommerce_admin_panel/common/widgets/layout/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

/// A reusable dashboard layout widget that includes header and sidebar
/// for consistent navigation across all dashboard screens
class DashboardLayout extends StatelessWidget {
  const DashboardLayout({
    super.key,
    required this.body,
    this.title,
    this.floatingActionButton,
  });

  /// The main content to display in the body
  final Widget body;

  /// Optional title for the app bar (if different from default)
  final String? title;

  /// Optional floating action button
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: THeader(scaffoldKey: scaffoldKey),
      drawer: const TSidebar(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
