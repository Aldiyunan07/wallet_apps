import 'package:flutter/material.dart';
import 'payment_number.dart';
import 'package:google_fonts/google_fonts.dart'; // Import untuk menggunakan Google Fonts

class ChoseTopup extends StatefulWidget {
  const ChoseTopup({super.key});

  @override
  State<ChoseTopup> createState() => _ChoseTopupState();
}

class _ChoseTopupState extends State<ChoseTopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Saldo', style: TextStyle(color: Colors.white)),
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
                                PaymentNumber(paymentMethod: 'BRI'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    _buildPaymentButton(
                      icon: Icons.wallet,
                      label: 'OVO',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentNumber(paymentMethod: 'OVO'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    _buildPaymentButton(
                      icon: Icons.wallet,
                      label: 'GOPAY',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentNumber(paymentMethod: 'GOPAY'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    _buildPaymentButton(
                      icon: Icons.credit_card,
                      label: 'CREDIT CARD',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentNumber(paymentMethod: 'CREDIT CARD'),
                          ),
                        );
                      },
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

  Widget _buildPaymentButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize:
            Size(double.infinity, 50), // Set the button width to fill the card
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
              Text(
                label,
                style: GoogleFonts.roboto(
                  // Gunakan GoogleFonts di sini
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 16.0, color: Color(0xFF623AA2)),
        ],
      ),
    );
  }
}
