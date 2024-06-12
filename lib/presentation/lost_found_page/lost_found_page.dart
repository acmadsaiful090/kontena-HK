import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LostFoundPage extends StatefulWidget {
  @override
  _LostFoundPageState createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  List<String> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (mounted) {
        setState(() {
          items = data.map((item) => item['title'] as String).toList();
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lost & Found',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                items[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                              onTap: () {
                                // Handle item click
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 60, 
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            // Handle FAB click
          },
          child: Icon(Icons.add, size: 36, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Color(0xFF27ae60),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
