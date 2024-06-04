import 'package:flutter/material.dart';
import 'send_money_screen.dart'; // Import SendMoneyScreen here

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final List<Contact> contacts = [
    Contact('Kim Nakyoung', '(+84) 343 343 343',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNKQhSihmLK_rXNEX249JWZ2z_A4qSKTrvVA&s'),
    Contact('Mayu cute', '(225) 555-0118',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF-R307Hgr83uHh7bQJsvRHHbLPor_WrSc5g&s'),
    Contact('Yeonji bocil', '(208) 555-0112',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkIOO757rdibNh-KOOcbyh-a3IhUL9jdo9og&s'),
    Contact('Duo Jagat', '(307) 555-0133',
        'https://i1.sndcdn.com/artworks-Knvw5DZYQjodNotA-6m7chw-t500x500.jpg'),
  ];
  int _selectedContactIndex = -1;
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    List<Contact> filteredContacts = contacts.where((contact) {
      return contact.name.toLowerCase().contains(_searchText.toLowerCase()) ||
          contact.phoneNumber.contains(_searchText);
    }).toList();

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
                labelText: 'Nama atau Nomor',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Kontak Anda',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(contact.imageUrl),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumber),
                    trailing: _selectedContactIndex == contacts.indexOf(contact)
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedContactIndex = contacts.indexOf(contact);
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _selectedContactIndex >= 0
                    ? () {
                        final selectedContact = contacts[_selectedContactIndex];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendMoneyScreen(
                              contactName: selectedContact.name,
                              contactImageUrl: selectedContact.imageUrl,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text('Continue'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                  textStyle: TextStyle(fontSize: 20),
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
  final String phoneNumber;
  final String imageUrl;

  Contact(this.name, this.phoneNumber, this.imageUrl);
}
