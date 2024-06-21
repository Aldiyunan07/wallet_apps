import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan/pages/history_page.dart';
import 'package:percobaan/pages/profile_page.dart';
import 'package:percobaan/pages/topup/chose_topup.dart';
import 'package:percobaan/pages/transfer/chose_page.dart';
import 'package:percobaan/pages/withdraw/chose_withdraw.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percobaan/pages/transfer/transfer_success_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _userProfile;
  List<Map<String, dynamic>> transferHistory = [];
  bool isLoading = false;
  int userId = 0;
  @override
  void initState() {
    super.initState();
    _userProfile = _fetchUserProfile();
    _fetchUserId();
    fetchTransferHistory();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId =
          prefs.getInt('user_id') ?? 0; // Default value 0 jika tidak ada nilai
    });
  }

  Future<void> fetchTransferHistory() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/transfer/history');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] != null) {
          setState(() {
            transferHistory =
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

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token is null');
    }

    String apiUrl = 'http://10.0.2.2:8000/api/me';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Gagal mendapatkan informasi User');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Navigate to after login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()), // Navigate to after login page
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
        // Navigate to after login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfilePage()), // Navigate to after login page
        );
        break;
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
              Color(0xFF623AA2), // Warna ungu OVO
              Colors.white,
            ],
            stops: [0.35, 0.35],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _userProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // Mendapatkan data dari respons JSON
                Map<String, dynamic> userProfile = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Wallet',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )),
                        IconButton(
                          icon: Icon(Icons.notifications, color: Colors.white),
                          onPressed: () {
                            // Implementasi fungsionalitas notifikasi
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Saldo anda',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Rp',
                          style: GoogleFonts.roboto(
                            textStyle : TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ), 
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '${userProfile['formatted']}',
                          style: GoogleFonts.roboto(
                            textStyle : TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _buildButton(Icons.add, 'Top Up', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChoseTopup(),
                                  ),
                                );
                              },
                                  size: 24.0,
                                  padding: EdgeInsets.only(left: 12.0)),
                              _buildButton(Icons.money_off, 'Withdraw', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChoseWithdraw(),
                                  ),
                                );
                              }, size: 24.0),
                              _buildButton(Icons.swap_horiz, 'Transfer', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChosePage(),
                                  ),
                                );
                              },
                                  size: 24.0,
                                  padding: EdgeInsets.only(right: 12.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Riwayat transfer',
                        style: GoogleFonts.roboto(
                          textStyle : TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ), 
                        ),
                      ),
                    ),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                              itemCount: transferHistory.length,
                              itemBuilder: (context, index) {
                                final transfer = transferHistory[index];
                                final transferId = transfer['id'];
                                final isReceiverIdOne =
                                    transfer['receiver_id'] == userId;
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TransferSuccessPage(
                                                transferId: transferId),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                'https://via.placeholder.com/40'),
                                          ),
                                          SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  isReceiverIdOne
                                                      ? '${transfer['sender']['name']}'
                                                      : '${transfer['receiver']['name']}',
                                                  style: GoogleFonts.roboto(
                                                    textStyle : TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ), 
                                                  ),
                                                ),
                                                Text(
                                                  '${transfer['date']}',
                                                  style: GoogleFonts.roboto(
                                                    textStyle : TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey,
                                                    ), 
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            isReceiverIdOne
                                                ? '+Rp.${transfer['formatted']}'
                                                : '-Rp.${transfer['formatted']}',
                                            style: GoogleFonts.roboto(
                                              textStyle : TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: isReceiverIdOne
                                                    ? Colors.green
                                                    : Colors.red,
                                              ), 
                                            ),
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
                );
              } else {
                return Center(child: Text('No data found'));
              }
            },
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
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            label: 'Profil',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed,
      {double size = 32.0, EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: size,
                      color: Colors.purple,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
