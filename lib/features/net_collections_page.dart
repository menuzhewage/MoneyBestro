import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/collections.dart';

class NetCollectionsPage extends StatefulWidget {
  const NetCollectionsPage({super.key});

  @override
  State<NetCollectionsPage> createState() => _NetCollectionsPageState();
}

class _NetCollectionsPageState extends State<NetCollectionsPage> {
  late Box<Collection> collectionBox;
  double totalQp = 0.0;
  double totalUq = 0.0;
  double totalSp = 0.0;
  double totalNb = 0.0;
  double totalRt = 0.0;
  double totalRv = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    collectionBox = await Hive.openBox<Collection>('collections');
    _loadNetCollections();
  }

  Future<void> _loadNetCollections() async {
    setState(() {
      isLoading = true;
    });

    double qpSum = 0.0;
    double uqSum = 0.0;
    double spSum = 0.0;
    double nbSum = 0.0;
    double rtSum = 0.0;
    double rvSum = 0.0;

    for (var collection in collectionBox.values) {
      qpSum += double.tryParse(collection.qp) ?? 0.0;
      uqSum += double.tryParse(collection.uq) ?? 0.0;
      spSum += double.tryParse(collection.sp) ?? 0.0;
      nbSum += double.tryParse(collection.nb) ?? 0.0;
      rtSum += double.tryParse(collection.rt) ?? 0.0;
      rvSum += double.tryParse(collection.rv) ?? 0.0;
    }

    setState(() {
      totalQp = qpSum;
      totalUq = uqSum;
      totalSp = spSum;
      totalNb = nbSum;
      totalRt = rtSum;
      totalRv = rvSum;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Net Collections',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else ...[
              _buildCard('Total QP', totalQp),
              _buildCard('Total UQ', totalUq),
              _buildCard('Total SP', totalSp),
              _buildCard('Total NB', totalNb),
              _buildCard('Total RT', totalRt),
              _buildCard('Total RV', totalRv),
            ],
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _loadNetCollections,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Refresh Data',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, double amount) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'LKR ${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    collectionBox.close();
    super.dispose();
  }
}
