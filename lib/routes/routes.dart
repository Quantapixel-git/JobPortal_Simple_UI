import 'package:get/get.dart';
import 'package:job/pages/admin_dashboard.dart';
import 'package:job/pages/admin_login.dart';
import 'package:job/pages/district_page.dart';
import 'package:job/pages/home_page.dart';
import 'package:job/pages/job_categories.dart';
import 'package:job/pages/job_detail.dart';
import 'package:job/pages/job_list.dart';
import 'package:job/pages/cv.dart';
import 'package:job/pages/splash_page.dart';

final List<GetPage> allPages = [
  GetPage(
    name: '/',
    page: () => SplashPage(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/home',
    page: () => HomePage(),
    transition: Transition.leftToRight,
  ),
  GetPage(
    name: '/district',
    page: () => Districts(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/jobcategories',
    page: () => JobCategories(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/joblist',
    page: () => JobList(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/jobdetail',
    page: () => JobDetail(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/adminlogin',
    page: () => AdminLogin(),
    transition: Transition.upToDown,
  ),
  GetPage(
    name: '/admindashboard',
    page: () => AdminDashboard(),
    transition: Transition.upToDown,
  ),
  GetPage(
    name: '/cv',
    page: () => Cv(),
    transition: Transition.downToUp,
  ),
];
