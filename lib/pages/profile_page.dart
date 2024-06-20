import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percobaan/home.dart';
import 'package:percobaan/pages/auth/login.dart';
import 'package:percobaan/pages/history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?>
      _userProfile; // Nullable Map for UserProfile

  @override
  void initState() {
    super.initState();
    _userProfile = _fetchUserProfile();
  }

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final apiUrl = 'http://10.0.2.2:8000/api/me';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null; // Return null in case of error
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final apiUrl = 'http://10.0.2.2:8000/api/logout';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        prefs.remove('token');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), // Navigate to after login page
        );
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Error loading user profile'));
            } else {
              String nama =
                  snapshot.data!['data']['name'] ?? 'Nama Tidak Diketahui';
              String phoneNumber = snapshot.data!['data']['phone_number'] ??
                  'Nomor Telepon Tidak Diketahui';
              String inbalance =
                  snapshot.data!['data']['inbalance']?.toString() ?? '0';
              String outbalance =
                  snapshot.data!['data']['outbalance']?.toString() ?? '0';

              return Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      // Profile Header
                      _buildProfileHeader(nama, phoneNumber),
                      SizedBox(height: 16.0),
                      // Balance Cards
                      _buildBalanceCard(Icons.arrow_downward, Colors.green,
                          'Uang Masuk', inbalance),
                      SizedBox(height: 16.0),
                      _buildBalanceCard(Icons.arrow_upward, Colors.red,
                          'Uang Keluar', outbalance),
                      SizedBox(height: 16.0),
                      // Menu Items
                      _buildMenuItem(Icons.person, 'Ubah Profil', () {}),
                      _buildMenuItem(Icons.vpn_key, 'Ubah PIN', () {}),
                      _buildMenuItem(Icons.logout, 'Logout', _logout),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with actual image URL
            ),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProfileHeader(String nama, String phoneNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Replace with actual image URL
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  nama,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
      IconData icon, Color color, String label, String value) {
    return Container(
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
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: color,
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              VerticalDivider(color: Colors.grey),
              Column(
                children: <Widget>[
                  Text(
                    'Rp $value',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Ensure the container takes full width
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 24.0),
            SizedBox(width: 12.0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.arrow_right),
          ],
        ),
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
