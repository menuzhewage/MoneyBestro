import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/section_page.dart';

class IntroPage extends StatelessWidget {
  final String username;

  const IntroPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person),
        backgroundColor: Colors.deepOrange,
        title: Text(
          'MoneyBestro',
          style: TextStyle(
            fontFamily: 'roboto',
            letterSpacing: 3.0,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome, $username!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'This app is designed to help you manage your finances better.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SectionPage(title: 'Collections')),
                );
              },
              child: sectionWidget('Collections', Colors.greenAccent),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SectionPage(title: 'Transactions')),
                );
              },
              child: sectionWidget(
                  'Transactions', const Color.fromARGB(255, 202, 111, 227)),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SectionPage(title: 'Notes')),
                );
              },
              child: sectionWidget(
                  'Notes', const Color.fromARGB(255, 128, 117, 223)),
            )
          ],
        ),
      ),
    );
  }

  Widget sectionWidget(String title, Color color) {
    return Container(
      width: 350,
      height: 150,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Tap to manage your $title',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }
}
