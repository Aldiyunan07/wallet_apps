import 'package:flutter/material.dart';

class TransferScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact('Lena Nguyen', '+84 343 343 343',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNKQhSihmLK_rXNEX249JWZ2z_A4qSKTrvVA&s'),
    Contact('Arlene McCoy', '(225) 555-0118',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF-R307Hgr83uHh7bQJsvRHHbLPor_WrSc5g&s'),
    Contact('Guy Hawkins', '(208) 555-0112',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkIOO757rdibNh-KOOcbyh-a3IhUL9jdo9og&s'),
    Contact('Arlene McCoy', '(307) 555-0133',
        'https://i1.sndcdn.com/artworks-Knvw5DZYQjodNotA-6m7chw-t500x500.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Nama atau Nomor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kontak Anda',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Add Nomor',
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
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(contact.imageUrl),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.phone),
                    trailing: Icon(Icons.check,
                        color: index == 0 ? Colors.green : Colors.transparent),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add your continue action here
                },
                child: Text('Continue'),
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

class Contact {
  final String name;
  final String phone;
  final String imageUrl;

  Contact(this.name, this.phone, this.imageUrl);
}
