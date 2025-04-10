import 'package:get/get.dart';
import 'package:job/pages/admin/admin_category.dart';
import 'package:job/pages/admin/admin_crousel.dart';
import 'package:job/pages/admin/admin_cv.dart';
import 'package:job/pages/admin/admin_dashboard.dart';
import 'package:job/pages/admin/admin_district.dart';
import 'package:job/pages/admin/admin_jobs.dart';
import 'package:job/pages/admin/admin_login.dart';
import 'package:job/pages/admin/admin_state.dart';
import 'package:job/pages/admin/adminchangepassword.dart';
import 'package:job/pages/mainbottomnav.dart';
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
    page: () => MainNavigation(),
    transition: Transition.leftToRight,
  ),
  GetPage(
    name: '/districts',
    page: () => Districts(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/jobcategories',
    page: () => CategoryPage(),
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
    // transition: Transition.upToDown,
  ),
  GetPage(
    name: '/adminstate',
    page: () => AdminStates(),
    // transition: Transition.upToDown,
  ),
  GetPage(
    name: '/admindistrict',
    page: () => AdminDistricts(),
    // transition: Transition.upToDown,
  ),
  GetPage(
    name: '/admincategory',
    page: () => AdminCategories(),
    // transition: Transition.upToDown,
  ),
  GetPage(
    name: '/adminjobs',
    page: () => AdminJobs(),
    // transition: Transition.upToDown,
  ),
  GetPage(
    name: '/adminuserprofile',
    page: () => AdminResumes(),
    // transition: Transition.upToDown,
  ),
  GetPage(
    name: '/admincarousel',
    page: () => AdminCarousel(),
    // transition: Transition.upToDown,
  ),
    GetPage(
    name: '/adminchangepassword',
    page: () => ChangePasswordPage(),
    // transition: Transition.upToDown,
  ),
  GetPage(
    name: '/cv',
    page: () => Cv(),
    transition: Transition.rightToLeft,
  ),
];
