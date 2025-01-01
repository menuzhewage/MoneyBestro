import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/add_collection_page.dart';
import 'package:flutter_application_1/models/collections.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'net_collections_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  late Box<Collection> collectionBox;
  List<Collection> collections = [];
  List<Collection> filteredCollections = [];
  double totalCollectionsAmount = 0.0;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Permission Denied')));
    }
  }

  Future<void> _initializeBox() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    collectionBox = await Hive.openBox<Collection>('collections');
    _loadCollections();
  }

  Future<void> _deleteCollection(int index) async {
    await collectionBox.deleteAt(index);
    _loadCollections();
  }

  Future<void> _clearAllCollections() async {
    await collectionBox.clear();
    _loadCollections();
  }

  Future<void> _generatePDF() async {
    await _requestPermissions();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Monthly Collections',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10.0),
              pw.ListView.builder(
                itemCount: filteredCollections.length,
                itemBuilder: (context, index) {
                  final collection = filteredCollections[index];
                  return pw.Text(
                    'Date: ${collection.date}, Name: ${collection.name}, Amount: LKR ${collection.amount}',
                    style: pw.TextStyle(fontSize: 16.0),
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final customFolder = Directory('${directory.path}/Collections');
        if (!await customFolder.exists()) {
          await customFolder.create(recursive: true);
        }

        String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final filePath = '${customFolder.path}/collections_$timestamp.pdf';

        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('PDF saved to $filePath')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving PDF: $e')));
    }
  }

  void _confirmClearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure you want to clear all data?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              _clearAllCollections();
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showEditCollectionDialog(int index) {
    final nameController = TextEditingController(text: collections[index].name);
    final amountController =
        TextEditingController(text: collections[index].amount.toString());
    final dateController = TextEditingController(text: collections[index].date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Collection'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Collection Name'),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final amount =
                    double.tryParse(amountController.text.trim()) ?? 0.0;
                final date = dateController.text.trim();

                if (name.isNotEmpty && amount > 0 && date.isNotEmpty) {
                  final updatedCollection = Collection(
                    name: name,
                    amount: amount,
                    date: date,
                    qp: '',
                    uq: '',
                    sp: '',
                    nb: '',
                    rt: '',
                    rv: '',
                  );
                  collectionBox.putAt(index, updatedCollection);
                  _loadCollections();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill all fields correctly')));
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    collectionBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Collections',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search'),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
                _loadCollections();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Collections: LKR ${totalCollectionsAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NetCollectionsPage()),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Go to Net Collections',
                        style: TextStyle(fontSize: 18)),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _generatePDF,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                ),
                ElevatedButton.icon(
                  onPressed: _confirmClearAllData,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Clear All'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredCollections.isEmpty
                ? const Center(child: Text('No collections available'))
                : ListView.builder(
                    itemCount: filteredCollections.length,
                    itemBuilder: (context, index) {
                      final collection = filteredCollections[index];
                      return Dismissible(
                        key: Key(collection.name ?? ''),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteCollection(index);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title:
                                Text(collection.name ?? 'Unnamed Collection'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${collection.date}'),
                                Text('Amount: LKR ${collection.amount}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditCollectionDialog(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddCollectionPage(onAddCollection: (newCollection) {
                _loadCollections();
                _addNewCollection(newCollection);
              }),
            ),
          );
          _loadCollections();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewCollection(Collection newCollection) {
    setState(() {
      collections.add(newCollection);
      filteredCollections.add(newCollection);
      totalCollectionsAmount += newCollection.amount ?? 0.0;
    });
  }

  void _loadCollections() {
    setState(() {
      collections = collectionBox.values.toList();
      filteredCollections = collections.where((collection) {
        return collection.name!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            collection.date!.contains(searchQuery);
      }).toList();

      totalCollectionsAmount =
          collections.fold(0.0, (sum, item) => sum + (item.amount ?? 0.0));
    });
  }
}
