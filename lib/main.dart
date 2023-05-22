import 'package:flutter/material.dart';
import 'package:prototype/src/config/app_router.dart';
import 'package:prototype/src/config/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appThemeData,
      routerConfig: appRouter,
    );
  }
}

//Use stateful when user press sth and need to refresh
// class RootPage extends StatefulWidget {
//   const RootPage({Key? key}) : super(key: key);

//   @override
//   State<RootPage> createState() => _RootPageState();
// }

// class _RootPageState extends State<RootPage> {
//   int currentPage = 0;

//   // List<Widget> pages = const [ChatPage(), RocketPage(), ProfilePage()];

//   void _onItemTapped(int index) {
//     setState(() {
//       currentPage = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[currentPage],
//       bottomNavigationBar: BottomNavigationBar(
//         // backgroundColor: black,
//         type: BottomNavigationBarType.fixed,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.forum_outlined),
//             label: 'Chat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.rocket_launch_outlined),
//             label: 'Rocket',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: currentPage,
//         selectedItemColor: Theme.of(context).colorScheme.primary,
//         unselectedItemColor: Colors.white,
//         onTap: _onItemTapped,
//         selectedLabelStyle: const TextStyle(fontSize: 0),
//         unselectedLabelStyle: const TextStyle(fontSize: 0),
//       ),
//     );
//   }
// }
