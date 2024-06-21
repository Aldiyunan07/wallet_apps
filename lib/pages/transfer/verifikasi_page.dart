import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percobaan/pages/transfer/transfer_success_page.dart';

class VerifikasiPage extends StatelessWidget {
  final int transferId;

  const VerifikasiPage({Key? key, required this.transferId}) : super(key: key);

  void _confirmTransfer(String pin, BuildContext context) async {
    try {
      String apiUrl =
          'http://10.0.2.2:8000/api/transfer/confirmation/$transferId';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'pin': pin}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        int transferId = responseData['id'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransferSuccessPage(transferId: transferId),
          ),
        );
      } else {
        print('Failed to confirm transfer: ${response.statusCode}');
        // Tambahkan penanganan jika gagal konfirmasi
        // Misalnya menampilkan snackbar atau alert
      }
    } catch (e) {
      print('Error confirming transfer: $e');
      // Tambahkan penanganan jika terjadi kesalahan
      // Misalnya menampilkan snackbar atau alert
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Verifikasi Transfer', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF623AA2),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF623AA2),
              Colors.white,
            ],
            stops: [0.35, 0.35],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Masukkan kode PIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  PinInput(onSubmit: (pin) {
                    _confirmTransfer(pin, context);
                  }), // Widget untuk input PIN tersembunyi
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aksi untuk tombol Konfirmasi
                        // Aksi dipindahkan ke dalam PinInput
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        backgroundColor: Color(0xFF623AA2),
                      ),
                      child: Text(
                        'Konfirmasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PinInput extends StatefulWidget {
  final Function(String) onSubmit;

  const PinInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  late TextEditingController pinController;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: pinController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      obscureText: true, // Mengubah teks menjadi tersembunyi
      style: TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '••••••',
        hintStyle: TextStyle(fontSize: 24),
        counterText: '',
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
      ),
      onSubmitted: (value) {
        widget.onSubmit(value);
      },
    );
  }
}
