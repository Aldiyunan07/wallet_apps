import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan/pages/topup/topup_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // Import untuk menggunakan Google Fonts

class InputSaldo extends StatefulWidget {
  final String paymentMethod;
  final String paymentNumber;

  const InputSaldo({
    Key? key,
    required this.paymentMethod,
    required this.paymentNumber,
  }) : super(key: key);

  @override
  _InputSaldoState createState() => _InputSaldoState();
}

class _InputSaldoState extends State<InputSaldo> {
  late String amount = ''; // String kosong untuk menghindari nilai null

  void _submitForm(BuildContext context) async {
    // Pastikan amount telah diisi oleh pengguna
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap masukkan jumlah top-up.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // URL API
    final apiUrl =
        Uri.parse('https://walletjwtapi.000webhostapp.com/api/transaction');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Kirim request POST ke API
      final response = await http.post(
        apiUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "amount": int.parse(amount), // Ubah string amount menjadi integer
          "paymentMethod": widget.paymentMethod,
          "paymentNumber": widget.paymentNumber,
          "type": "topup",
        }),
      );

      // Cek status response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Top-up berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopupSuccess(
              transactionId: responseData['id'],
            ),
          ),
        );
      } else {
        // Jika gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal melakukan top-up. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Tangani jika terjadi error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input Saldo',
          style: TextStyle(color: Colors.white),
        ),
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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    "SAYA AKAN ISI SALDO MENGGUNAKAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 40.0,
                              color: Color(0xFF623AA2),
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.paymentMethod,
                                  style: GoogleFonts.roboto(
                                    // Gunakan GoogleFonts di sini
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  widget.paymentNumber,
                                  style: GoogleFonts.roboto(
                                    // Gunakan GoogleFonts di sini
                                    textStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(height: 8.0),
                        Text(
                          "Masukkan jumlah top-up",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              amount = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Rp.",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "Biaya transaksi sesuai dengan kebijakan bank",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: Colors.transparent,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _submitForm(
              context), // Panggil fungsi _submitForm saat tombol ditekan
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            backgroundColor: Color(0xFF623AA2),
          ),
          child: Text(
            "KONFIRMASI",
            style: GoogleFonts.roboto(
              // Gunakan GoogleFonts di sini
              textStyle: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
