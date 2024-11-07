import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kontena_hk/presentation/home_page/detail_room_page.dart';
import 'package:kontena_hk/api/data/room_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kontena_hk/models/room.dart';
// Import your pages
import 'package:kontena_hk/presentation/lost_found_page/lost_found_page.dart';
import 'package:kontena_hk/presentation/profile_page.dart/profile_page.dart';
import 'package:kontena_hk/presentation/reservation_page/reservation_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    // ReservationPage(),
    LostFoundPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy', 'id');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Column(
          children: [
            Image.asset(
              'assets/image/logo-kontena.png',
              height: 45,
            ),
            Text(
              _formatDateTime(DateTime.now()),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Room',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.business),
          //   label: 'Reservation',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Lost & Found',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF27ae60),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoading = true;
  final Random random = Random();
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
    _searchController.addListener(_filterItems);
  }

  Future<void> fetchItems() async {
    setState(() {
      isLoading = true; // Start loading immediately
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('session_cookie');
      if (cookie == null) {
        throw Exception('No session cookie found. Please log in again.');
      }
      final request = RoomRequest(
        cookie: cookie,
        fields: '["*"]',
      );
      final response = await requestItem(requestQuery: request);
      setState(() {
        if (response is List) {
          items = response.map((roomData) {
            return {
              'name': roomData['name']?.toString() ?? '',
              'room_name': roomData['room_name']?.toString() ?? '',
              'room_type_name': roomData['room_type_name']?.toString() ?? '',
              'status': roomData['room_status']?.toString() ?? '',
              'can_clean': roomData['can_clean'] ?? 0,
              'can_check': roomData['can_check'] ?? 0,
              'is_damaged': roomData['is_damaged'] ?? 0,
            };
          }).toList();
          filteredItems = items;
        } else {
          throw Exception('Unexpected response format');
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        print(e);
      });
    }
  }
  

String? getFirstFieldWithOneAtIndex(int index) {
  if (index < 0 || index >= filteredItems.length) {
    print('Index di luar batas');
    return null;
  }
  final roomData = filteredItems[index];
  Map<String, int> fields = {
    'can_clean': roomData['can_clean'] ?? 0,
    'can_check': roomData['can_check'] ?? 0,
    'is_damaged': roomData['is_damaged'] ?? 0,
  };

  for (var entry in fields.entries) {
    if (entry.value == 1) {
      return entry.key;
    }
  }

  return null; 
}


  void _filterItems() {
    setState(() {
      String searchText = _searchController.text.toLowerCase();
      filteredItems = items.where((item) {
        return item['room_name']
                    ?.toString()
                    .toLowerCase()
                    .contains(searchText) ==
                true ||
            item['room_type_name']
                    ?.toString()
                    .toLowerCase()
                    .contains(searchText) ==
                true ||
            item['name']?.toString().toLowerCase().contains(searchText) ==
                true ||
            item['status']?.toString().toLowerCase().contains(searchText) ==
                true;
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: Text('Filter 1'),
                    value: selectedFilters.contains('Filter 1'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedFilters.add('Filter 1');
                        } else {
                          selectedFilters.remove('Filter 1');
                        }
                      });
                      _filterItems();
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Filter 2'),
                    value: selectedFilters.contains('Filter 2'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedFilters.add('Filter 2');
                        } else {
                          selectedFilters.remove('Filter 2');
                        }
                      });
                      _filterItems();
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Filter 3'),
                    value: selectedFilters.contains('Filter 3'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedFilters.add('Filter 3');
                        } else {
                          selectedFilters.remove('Filter 3');
                        }
                      });
                      _filterItems();
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF27ae60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Apply Filter',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 14)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // String getRandomStatus() {
  //   List<String> status = ['OC', 'OD', 'VD', 'VC', 'VR'];
  //   return status[random.nextInt(5)];
  // }

  Color getColorForLabel(String label) {
    if (label == "OC") return Colors.red;
    if (label == "OD") return Colors.red;
    if (label == "VD") return Colors.green;
    if (label == "VC") return Colors.blue;
    if (label == "VR") return Colors.blue;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchItems,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _showFilterSheet,
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                    ? Center(child: Text('No rooms found.'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final label = filteredItems[index]['status'];
                          final color = getColorForLabel(label);

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
                                    '${filteredItems[index]['room_name']}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Room Type: ${filteredItems[index]['room_type_name']}',
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        filteredItems[index]['name'] !=
                                                null // Change this as per your data
                                            ? filteredItems[index]['name']!
                                                .toString()
                                            : 'No Guest',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                 onTap: () {
                                    String? fieldWithOne = getFirstFieldWithOneAtIndex(index);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailRoomPage(
                                          data: filteredItems[index]['name'],
                                          status: label,
                                          detail: fieldWithOne ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                  trailing: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
