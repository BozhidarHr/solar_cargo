// // lib/main_screen.dart
// import 'package:flutter/material.dart';
// import 'package:solar_cargo/screens/create_report/view/create_report_stepper.dart';
//
// import 'home_screen.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//
//   final List<Widget> _pages = [
//     const HomeScreen(),
// const CreateDeliveryReportScreen(),
//   ];
//
//   // void _onTabTapped(int index) {
//   //   setState(() => _currentIndex = index);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       // bottomNavigationBar: BottomNavigationBar(
//       //   currentIndex: _currentIndex,
//       //   onTap: _onTabTapped,
//       //   items: const [
//       //     // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//       //     // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//       //   ],
//       // ),
//     );
//   }
// }
