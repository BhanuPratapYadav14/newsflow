import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:newsflow/app/core/routes/appPageName.dart';

import 'app/core/controllers/bookmark_controller.dart';
import 'app/core/data/datasources/news_local_data_source.dart';
import 'app/core/data/datasources/news_remote_data_source.dart';
import 'app/core/data/repositories/news_repository_impl.dart';
import 'app/core/domain/repositories/news_repository.dart';
import 'app/core/routes/appPages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Map>('bookmarksBox');

  // Dependency injection setup for Clean Architecture
  final http.Client httpClient = http.Client();
  final NewsRemoteDataSource remoteDataSource = NewsRemoteDataSourceImpl(client: httpClient);
  final NewsLocalDataSource localDataSource = NewsLocalDataSourceImpl();
  
  final NewsRepository repository = NewsRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  // Register NewsRepository globally
  Get.put<NewsRepository>(repository, permanent: true);

  // Initialize BookmarkController globally
  Get.put(BookmarkController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
      ),
      initialRoute: AppPageName.splash,
      getPages: AppPages.pages,
    );
  }
}
