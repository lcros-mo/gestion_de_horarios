import 'package:flutter/material.dart';
import 'services/db_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final DBService _dbService = DBService();
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    final data = await _dbService.getEntries();
    setState(() {
      _entries = data;
    });
  }

  void _addEntry(String type) async {
    await _dbService.insertEntry(type);
    _loadEntries();
  }

  void _deleteEntry(int id) async {
    await _dbService.deleteEntry(id);
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _addEntry('Entrada'),
                  child: const Text('Registrar Entrada'),
                ),
                ElevatedButton(
                  onPressed: () => _addEntry('Salida'),
                  child: const Text('Salida'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${_entries[index]['type']}: ${_entries[index]['timestamp']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteEntry(_entries[index]['id']),
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
