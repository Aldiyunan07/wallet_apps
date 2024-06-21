import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percobaan/pages/topup/input_saldo.dart'; // Import untuk FilteringTextInputFormatter

class PaymentNumber extends StatelessWidget {
  final String paymentMethod;

  const PaymentNumber({Key? key, required this.paymentMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _paymentNumber = '';

    void _submitForm() {
      if (_paymentNumber.isEmpty) {
        // Tampilkan pesan error jika input kosong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Masukkan nomor kartu atau nomor dengan benar.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Redirect ke halaman baru (InputSaldo) dengan mengirimkan data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputSaldo(
            paymentMethod: paymentMethod,
            paymentNumber: _paymentNumber,
          ),
        ),
      );
    }

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
                            Text(
                              paymentMethod,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey),
                        SizedBox(height: 8.0),
                        Text(
                          "Input Nomor Kartu / Nomor",
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
                            keyboardType:
                                TextInputType.number, // Hanya keyboard angka
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              // Hapus LengthLimitingTextInputFormatter(16)
                            ],
                            onChanged: (value) {
                              _paymentNumber = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan nomor kartu atau nomor",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Text(
                        //   "Biaya transaksi sesuai dengan kebijakan bank",
                        //   style: TextStyle(
                        //     fontSize: 12.0,
                        //     color: Colors.grey,
                        //   ),
                        // ),
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
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            backgroundColor: Color(0xFF623AA2),
          ),
          child: Text(
            "KONFIRMASI",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
