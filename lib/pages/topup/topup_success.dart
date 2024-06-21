import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:percobaan/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopupSuccess extends StatefulWidget {
  final int transactionId;

  const TopupSuccess({Key? key, required this.transactionId}) : super(key: key);

  @override
  _TopupSuccessState createState() => _TopupSuccessState();
}

class _TopupSuccessState extends State<TopupSuccess> {
  late Future<Map<String, dynamic>> futureTransactionData;

  @override
  void initState() {
    super.initState();
    futureTransactionData = fetchTransactionData(widget.transactionId);
  }

  Future<Map<String, dynamic>> fetchTransactionData(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/transaction/${widget.transactionId}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load transfer data');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Transaction Berhasil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                      future: futureTransactionData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return Center(child: Text('No Data Found'));
                        } else {
                          final transactionData = snapshot.data!;
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.all(8),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'EWALLET',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            transactionData['date'],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            transactionData['time'],
                                            style: TextStyle(fontSize: 14),
                                          )
                                        ],
                                      )),
                                      Text(
                                        'ID Transaction : ${transactionData['id']}',
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey[300]),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(Icons.credit_card, size: 24),
                                      SizedBox(width: 12),
                                      Text(
                                        'Detail Pembayaran',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        'Metode Pembayaran',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        transactionData['paymentMethod'] ?? 'Null',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Payment Number',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        transactionData['paymentNumber'] ?? 'Null',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          color: Colors.green, size: 24),
                                      SizedBox(width: 12),
                                      Text(
                                        'Transaction Success',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        'Total ${transactionData['type']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Rp ${transactionData['formatted']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey[300]),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()), // Ganti dengan halaman HomePage Anda
                                          (Route<dynamic> route) => false,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        backgroundColor: Color(0xFF623AA2),
                                      ),
                                      child: Text(
                                        'Beranda',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
