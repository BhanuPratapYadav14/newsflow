import 'package:get/get.dart';
import 'package:newsflow/app/core/routes/appPageName.dart';

import '../../features/articleDetail/presentation/bindings/articleDetailBinding.dart';
import '../../features/articleDetail/presentation/pages/articleDetailScreen.dart';
import '../../features/bookmarks/presentation/pages/bookmarksScreen.dart';
import '../../features/homeScreen/presentation/binding/homeScreenBinding.dart';
import '../../features/homeScreen/presentation/pages/homeScreen.dart';
import '../../features/newsListScreen/presentation/bindings/newsListBinding.dart';
import '../../features/newsListScreen/presentation/pages/newsListScreen.dart';
import '../../features/splashScreen/presentation/bindings/splashScreenBinding.dart';
import '../../features/splashScreen/presentation/pages/splash_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppPageName.splash, page: () => SplashScreen(), binding: SplashScreenBinding()),
    GetPage(name: AppPageName.home, page: () => const Homescreen(), binding: HomeScreenBinding()),
    GetPage(name: AppPageName.newsList, page: () => const NewsListScreen(), binding: NewsListBinding()),
    GetPage(name: AppPageName.ArticleDetail, page: () => const ArticleDetailScreen(), binding: ArticleDetailBinding()),
    GetPage(name: AppPageName.bookmarks, page: () => const BookmarksScreen()),
    // GetPage(name: AppPageName.onboarding, page: () => const OnboardingScreen()),
    // GetPage(name: AppPageName.login, page: () => const LoginScreen()),
    // GetPage(name: AppPageName.register, page: () => const RegisterScreen()),
    // GetPage(name: AppPageName.categories, page: () => const CategoriesScreen()),
    // GetPage(name: AppPageName.search, page: () => const SearchScreen()),
    // GetPage(name: AppPageName.settings, page: () => const SettingsScreen()),
  ];
}