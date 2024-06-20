import 'package:flutter/material.dart';

class ChosePage extends StatefulWidget {
  const ChosePage({super.key});

  @override
  State<ChosePage> createState() => _ChosePageState();
}

class _ChosePageState extends State<ChosePage> {
  List<String> avatarUrls = [
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
  ];

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    List<String> displayedAvatars =
        showAll ? avatarUrls : avatarUrls.take(8).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Uang'),
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
            stops: [0.30, 0.30],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kirim Cepat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemCount: displayedAvatars.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(displayedAvatars[index]),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Nama ${index + 1}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      if (avatarUrls.length > 8)
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                showAll = !showAll;
                              });
                            },
                            child: Text(
                              showAll ? 'Tampilkan Sedikit' : 'Lihat Semua',
                              style: TextStyle(
                                fontSize: 18, // Besarkan ukuran font
                                color: Color(0xFF623AA2),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
