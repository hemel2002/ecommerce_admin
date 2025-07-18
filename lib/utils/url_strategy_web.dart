// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void configureApp() {
  // Remove hash from URL for web
  html.window.history.pushState(null, '', html.window.location.pathname);
}
