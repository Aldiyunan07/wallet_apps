import 'package:flutter/material.dart';

class TopUpScreen extends StatefulWidget {
  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  int _selectedPaymentMethod = 0;

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod('BRI', 'Bank',
        'https://play-lh.googleusercontent.com/h_PjuN71zmHSHdynKxkl9R_j2ambqn978mfSEwmzPn_XzQWrBDr1mBM_QIDj__Uxu4w=w480-h960-rw'),
    PaymentMethod('BCA', 'Bank',
        'https://play-lh.googleusercontent.com/ggZzVVDWsTm7gSnVl8m3cNFgoeUN2r7dhAZdB8lz0d_s6ZcYOkvUQdbG3dPU5LHZnWvc=s96-rw'),
    PaymentMethod('Blu Mobile', 'Bank Digital',
        'https://play-lh.googleusercontent.com/-OdereTd6Aw2fdNV7K_N90Mhhzr3tcsuDlkFuYKZf7PgkM33SexLWRFmnhcRPuu52Q'),
    PaymentMethod('Dana', 'E-wallet',
        'https://play-lh.googleusercontent.com/v0UW49SrkxIzfRRhYArIJvP456-QeKT9-1Yxk19gwJESPidGAnJS7n7_sHZe81NpX_E=s96-rw'),
    PaymentMethod('GoPay', 'E-wallet',
        'https://play-lh.googleusercontent.com/-gl80k-nLhRwy_ovgo6o3ro2QX76sAJPpz7-azG-MXeLMaUSYtmZDT3GTM10wKqGMJSZ=w480-h960-rw'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = paymentMethods[index];
                  return ListTile(
                    leading: Image.network(paymentMethod.imageUrl, width: 50.0),
                    title: Text(paymentMethod.name),
                    subtitle: Text(paymentMethod.type),
                    trailing: _selectedPaymentMethod == index
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = index;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add your confirm action here
                },
                child: Text('Konfirmasi'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  final String name;
  final String type;
  final String imageUrl;

  PaymentMethod(this.name, this.type, this.imageUrl);
}
