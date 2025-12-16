import 'package:flutter/material.dart';
import 'screens/user/user_login.dart';
import 'screens/user/user_register.dart';
import 'screens/widgets/user_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/user_login',
      routes: {
        '/user_login': (context) => const UserLoginScreen(),
        '/user_register': (context) => const UserRegisterScreen(),
        '/user_navbar': (context) => const UserNavbar(currentIndex: 0),
      },
    );
  }
}
