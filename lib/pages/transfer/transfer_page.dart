import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan/pages/transfer/verifikasi_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransferPage extends StatefulWidget {
  final int userId;

  const TransferPage({Key? key, required this.userId}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String name = "Nama Pengguna";
  String phoneNumber = "081234567890";
  bool isLoading = true;
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/user/${widget.userId}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        name = data['name'] ?? "Nama Pengguna";
        phoneNumber = data['phone_number'] ?? "081234567890";
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> performTransfer(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final String apiUrl = 'http://10.0.2.2:8000/api/transfer';

    final Map<String, dynamic> requestData = {
      "user_id": widget.userId.toString(),
      "amount": amount,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['data'];
      int transferId = responseData['id'];

      // Redirect ke VerifikasiPage dengan mengirimkan transferId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifikasiPage(transferId: transferId),
        ),
      );
    } else {
      // Gagal melakukan transfer
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal melakukan transfer. Silakan coba lagi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Page', style: TextStyle(color: Colors.white)),
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  phoneNumber,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Jumlah Kirim',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Rp0',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ambil nilai amount dari TextField
                              String amountText = amountController.text.trim();
                              int amount = int.tryParse(amountText) ?? 0;

                              // Panggil method untuk melakukan transfer
                              performTransfer(amount);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              backgroundColor:
                                  Color(0xFF623AA2), // Warna ungu sesuai tema
                            ),
                            child: Text(
                              'Transfer',
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
