import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan/home.dart';
import 'package:percobaan/pages/profile_page.dart';
import 'package:percobaan/pages/topup/topup_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> transactionHistory = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTransactionHistory();
  }

  Future<void> fetchTransactionHistory() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/transaction/history');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Ganti dengan token Bearer Anda

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] != null) {
          setState(() {
            transactionHistory =
                List<Map<String, dynamic>>.from(responseData['data']);
            isLoading = false;
          });
        }
      } else {
        print(
            'Failed to load transaction history. Error: ${response.statusCode}');
        isLoading = false;
      }
    } catch (error) {
      print('Error loading transaction history: $error');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF623AA2), // Purple color
              Colors.white,
            ],
            stops: [0.35, 0.35],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 24.0),
              Text(
                'Riwayat Transaksi',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: transactionHistory.length,
                        itemBuilder: (context, index) {
                          final transaction = transactionHistory[index];
                          final transactionId = transaction['id'];
                          IconData iconData = transaction['type'] == 'topup'
                              ? Icons.arrow_circle_up
                              : Icons.arrow_circle_down;
                          Color iconColor = transaction['type'] == 'topup'
                              ? Colors.green
                              : Colors.red;
                          return InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TopupSuccess(
                                      transactionId: transactionId),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Icon(iconData, color: iconColor),
                                title: Row(
                                  children: [
                                    Text(
                                      '${transaction['type'].toUpperCase()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Rp '
                                          '${transaction['formatted']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${transaction['date']}',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '${transaction['time']}',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with actual image URL
            ),
            label: 'Profil',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryPage(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
        break;
    }
  }
}
