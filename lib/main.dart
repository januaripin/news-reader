import 'package:flutter/material.dart';
import 'package:news_reader_app/core/constants/app_colors.dart';
import 'package:news_reader_app/features/root/presentation/pages/root_page.dart';
import 'package:news_reader_app/generated/l10n.dart';

import 'service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(NewsReaderApp());
}

class NewsReaderApp extends StatefulWidget {
  @override
  _NewsReaderAppState createState() => _NewsReaderAppState();
}

class _NewsReaderAppState extends State<NewsReaderApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: S().app_name,
      initialRoute: '/',
      onGenerateRoute: _getRoute,
      theme: ThemeData(
        primaryColor: AppColors.black[50],
        fontFamily: 'OpenSans',
      ),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => _getPage(settings),
      fullscreenDialog: true,
    );
  }

  Widget _getPage(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return RootPage();
      default:
        return RootPage();
    }
  }
}
