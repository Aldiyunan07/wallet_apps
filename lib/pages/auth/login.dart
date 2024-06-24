import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan/home.dart';
import 'package:percobaan/pages/auth/register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = _phoneNumberController.text.trim();
      String pin = _pinController.text.trim();

      String apiUrl = 'http://10.0.2.2:8000/api/login';

      try {
        var response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'phone_number': phoneNumber,
            'pin': pin,
          },
        );

        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']);
          await prefs.setInt('user_id', responseData['data']['id']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login berhasil!', style: GoogleFonts.roboto(),),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );

        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Phone number atau pin salah!',
                style: GoogleFonts.roboto(),
              ),
              backgroundColor: Colors.red,
            ),
          );

        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyambungkan dengan server',
              style: GoogleFonts.roboto(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200,
                child: Image.asset(
                    'assets_img/images.png'), // Load image from local asset
              ),
              SizedBox(height: 24.0),
              Text(
                'E-WALLET',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      // Hapus inputFormatters
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _pinController,
                      decoration: InputDecoration(
                        labelText: 'Pin',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      // Hapus inputFormatters
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      height: 50.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6A1B9A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'atau',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _goToRegisterPage(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFF6A1B9A)),
                    ),
                  ),
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
