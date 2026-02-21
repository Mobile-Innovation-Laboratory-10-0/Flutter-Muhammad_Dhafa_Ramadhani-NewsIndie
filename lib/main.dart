import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'models/bookmark_model.dart';
import 'models/app_usage_model.dart';
import 'pages/main_navigation.dart';
import 'services/analytics_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BookmarkAdapter());
  Hive.registerAdapter(AppUsageAdapter());

  await Hive.openBox<Bookmark>('bookmarks');
  await Hive.openBox<AppUsage>('app_usage');

  AnalyticsService().trackAppOpen();

  timeago.setLocaleMessages('id', timeago.IdMessages());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NewsIndie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainNavigation(),
    );
  }
}
