// import 'package:flutter/material.dart';
// import 'home_page.dart';
// import 'cv.dart';
// import 'dart:async'; // For Timer

// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});

//   @override
//   _MainNavigationState createState() => _MainNavigationState();
// }

// class _MainNavigationState extends State<MainNavigation>
//     with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   DateTime? _lastBackPressed;

//   final List<Widget> _pages = [
//     const HomePage(),
//     const Cv(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     _animationController.forward().then((_) => _animationController.reverse());
//   }

//   Future<bool> _onWillPop() {
//     DateTime now = DateTime.now();
//     if (_lastBackPressed == null ||
//         now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
//       _lastBackPressed = now;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Press back again to exit"),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return Future.value(false);
//     }
//     return Future.value(true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 300),
//           transitionBuilder: (child, animation) =>
//               FadeTransition(opacity: animation, child: child),
//           child: _pages[_selectedIndex],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Colors.yellow,
//           selectedItemColor: Colors.black,
//           unselectedItemColor: Colors.grey,
//           type: BottomNavigationBarType.fixed,
//           elevation: 10,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: [
//             BottomNavigationBarItem(
//               icon: ScaleTransition(
//                 scale: _selectedIndex == 0
//                     ? _animation
//                     : const AlwaysStoppedAnimation(1.0),
//                 child: const Icon(Icons.home),
//               ),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: ScaleTransition(
//                 scale: _selectedIndex == 1
//                     ? _animation
//                     : const AlwaysStoppedAnimation(1.0),
//                 child: const Icon(Icons.upload_file),
//               ),
//               label: 'Upload CV',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cv.dart';
import 'dart:async'; // For Timer

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  DateTime? _lastBackPressed;

  final List<Widget> _pages = [
    const HomePage(),
    const Cv(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.forward().then((_) => _animationController.reverse());
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Prevent the app from exiting
    }
    return true; // Allow the app to exit
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.yellow,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: ScaleTransition(
                scale: _selectedIndex == 0
                    ? _animation
                    : const AlwaysStoppedAnimation(1.0),
                child: const Icon(Icons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ScaleTransition(
                scale: _selectedIndex == 1
                    ? _animation
                    : const AlwaysStoppedAnimation(1.0),
                child: const Icon(Icons.upload_file),
              ),
              label: 'Upload CV',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
