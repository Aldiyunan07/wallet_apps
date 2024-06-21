import 'package:flutter/material.dart';
import 'package:percobaan/pages/withdraw/insert_withdraw.dart';

class ChoseWithdraw extends StatefulWidget {
  const ChoseWithdraw({super.key});

  @override
  State<ChoseWithdraw> createState() => _ChoseWithdrawState();
}

class _ChoseWithdrawState extends State<ChoseWithdraw> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Kirim & Tarik Tunai', style: TextStyle(color: Colors.white)),
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
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPaymentButton(
                      icon: Icons.credit_score,
                      label: 'BRI',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InsertWithdraw(paymentMethod: 'BRI'),
                          ),
                        );
                      },
                      additionalText:
                          'VIA ATM', // Tambahkan teks VIA ATM di sini
                    ),
                    SizedBox(height: 16.0),
                    _buildPaymentButton(
                      icon: Icons.wallet,
                      label: 'BCA',
                      onPressed: () {
                        // Action when OVO button is pressed
                      },
                    ),
                    SizedBox(height: 16.0),
                    _buildPaymentButton(
                      icon: Icons.wallet,
                      label: 'BNI',
                      onPressed: () {
                        // Action when GOPAY button is pressed
                      },
                    ),
                    SizedBox(height: 16.0),
                    _buildPaymentButton(
                      icon: Icons.credit_card,
                      label: 'ALFAMART',
                      onPressed: () {
                        // Action when CREDIT CARD button is pressed
                      },
                      additionalText:
                          'VIA KASIR OUTLET', // Tambahkan teks VIA KASIR OUTLET di sini
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    String? additionalText, // Teks tambahan yang opsional
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (additionalText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              additionalText,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
                double.infinity, 50), // Set the button width to fill the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(color: Colors.black),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24.0, color: Colors.black),
                  SizedBox(width: 16.0),
                  Text(label,
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                ],
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16.0, color: Color(0xFF623AA2)),
            ],
          ),
        ),
      ],
    );
  }
}
