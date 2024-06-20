import 'package:flutter/material.dart';
import 'package:percobaan/home.dart';
import 'package:percobaan/pages/transfer/transfer_page.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/transfer': (context) => TransferPage(userId: 0),
      },
    );
  }
}
