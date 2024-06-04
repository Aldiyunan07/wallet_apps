import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String profileImageUrl =
      'https://pbs.twimg.com/profile_images/1678047241037070337/Q2r5XAW__400x400.jpg';
  final String userName = 'FullName Example';
  final double totalBalance = 14000000;
  final List<Transaction> transactions = [
    Transaction('Udin Karpet', -50000, DateTime(2021, 7, 1)),
    Transaction('Dadang Uhuy', 100000, DateTime(2021, 7, 1)),
    Transaction('Ida Nia', -30000, DateTime(2021, 7, 1)),
    Transaction('Udin Karpet', -50000, DateTime(2021, 7, 1)),
    Transaction('Dadang Uhuy', 100000, DateTime(2021, 7, 1)),
    Transaction('Ida Nia', -30000, DateTime(2021, 7, 1)),
    Transaction('Mahnu', 10000, DateTime(2021, 7, 1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                  radius: 40.0,
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Saldo',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Rp. ${totalBalance.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Icon(Icons.visibility, color: Colors.grey[600])
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Text(
              'Layanan',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/topup');
                  },
                  child: ServiceIcon(icon: Icons.add, label: 'Top Up'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/transfer');
                  },
                  child: ServiceIcon(icon: Icons.send, label: 'Transfer'),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaksi',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    title: Text(transaction.description),
                    subtitle: Text(
                        '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
                    trailing: Text(
                      'Rp. ${transaction.amount < 0 ? '' : '+'}${transaction.amount.abs().toStringAsFixed(0)}',
                      style: TextStyle(
                        color:
                            transaction.amount < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  ServiceIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, size: 30.0, color: Colors.blue),
        ),
        SizedBox(height: 8.0),
        Text(label),
      ],
    );
  }
}

class Transaction {
  final String description;
  final double amount;
  final DateTime date;

  Transaction(this.description, this.amount, this.date);
}
