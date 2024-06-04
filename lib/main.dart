import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'transfer_screen.dart';
import 'topup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Wallet',
      home: HomeScreen(),
      routes: {
        '/transfer': (context) => TransferScreen(),
        '/topup': (context) => TopUpScreen(),
      },
    );
  }
}
