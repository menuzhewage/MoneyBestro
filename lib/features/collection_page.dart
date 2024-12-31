import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/collection.dart';
import 'package:flutter_application_1/screens/add_collection_page.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  bool isBoxOpen = false;
  late Box<Collection> collectionBox;
  List<Map<String, dynamic>> collections = [];

  double getTotalCollections() {
    return collections.fold(0, (sum, item) => sum + item['amount']);
  }

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    if (!isBoxOpen) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      try {
        collectionBox = await Hive.openBox<Collection>('collections');
        isBoxOpen = true; 
        loadCollections();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error opening box: $e')),
          );
        }
      }
    }
  }

  Future<void> closeBox() async {
    if (isBoxOpen) {
      await collectionBox.close();
      isBoxOpen = false;
    }
  }

  Future<void> saveCollections() async {
    try {
      // Clear the existing data in the box before saving the new data
      await collectionBox.clear();

      // Save the collections to the box
      for (var collection in collections) {
        Collection newCollection = Collection(
          name: collection['name'],
          amount: collection['amount'],
          date: collection['date'],
        );
        await collectionBox.add(newCollection);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    }
  }

  Future<void> loadCollections() async {
    final allCollections = <Map<String, dynamic>>[];
    for (int i = 0; i < collectionBox.length; i++) {
      allCollections
          .add(collectionBox.get(i.toString()) as Map<String, dynamic>);
    }
    setState(() {
      collections = allCollections;
    });
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Monthly Collections',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10.0),
              pw.ListView(
                children: collections.map((collection) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 5.0),
                    child: pw.Text(
                      'Date: ${collection['date']}, Name: ${collection['name']}, Amount: LKR ${collection['amount']}',
                      style: pw.TextStyle(fontSize: 16.0),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/collections.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving PDF: $e')),
      );
    }
  }

   @override
  void dispose() {
    if (isBoxOpen) {
      collectionBox.close();
      isBoxOpen = false;
    }
    super.dispose();
  }


  void clearAllData() {
    setState(() {
      collections.clear();
    });

    saveCollections();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All data cleared')),
    );
  }

  void confirmClearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure you want to clear all data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              clearAllData();
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }


  void addCollectionItem(String title, double amount, String date) {
    setState(() {
      collections.add({
        'name': title,
        'amount': amount,
        'date': date,
      });
    });
    saveCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Collections',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: generatePDF,
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Collections here'),
          Text('Total collections : LKR ${getTotalCollections()}'),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCollectionPage(
                          onAddCollection: (newCollection) {
                            setState(() {
                              // Make sure to use the Collection directly here
                              collections.add({
                                'name': newCollection.name,
                                'amount': newCollection.amount,
                                'date': newCollection.date,
                              });
                            });
                            saveCollections();
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.lightBlueAccent,
                    margin: EdgeInsets.all(12),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Add Collection'),
                          Icon(Icons.add_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCollectionPage(
                          onAddCollection: (newCollection) {
                            setState(() {
                              // Add the Collection object directly to collections list
                              collections.add({
                                'name': newCollection.name,
                                'amount': newCollection.amount,
                                'date': newCollection.date,
                              });
                            });
                            saveCollections();
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.lightBlueAccent,
                    margin: EdgeInsets.all(12),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Net Collection'),
                          Icon(Icons.account_balance_wallet_rounded)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: generatePDF,
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text('Monthly PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: confirmClearAllData,
                  icon: Icon(Icons.delete_forever),
                  label: Text('Clear All Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final collection = collections[index];
                return Dismissible(
                  key: Key(collection['name']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      collections.removeAt(index);
                    });
                    saveCollections();
                  },
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(collection['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${collection['date']}'),
                          SizedBox(height: 4.0),
                          Text('Amount: LKR ${collection['amount']}'),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
