import 'package:flutter/material.dart';

class NetCollectionsPage extends StatelessWidget {
  const NetCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Net Collections'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          'This is the Net Collections page.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
