import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jc_hk/presentation/home_page/detail_room_page.dart';
import 'package:jc_hk/api/data/room_api.dart';
import 'package:jc_hk/app_state.dart';
import 'package:jc_hk/api/Employee_api.dart';
import 'package:jc_hk/utils/theme.helper.dart';
import 'package:jc_hk/widget/bottom_navigation.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
// Import your pages
import 'package:jc_hk/presentation/lost_found_page/lost_found_page.dart';
import 'package:jc_hk/presentation/profile_page.dart/profile_page.dart';

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
              'assets/image/logo_housekeeping.png',
              height: 45,
            ),
            Text(
              _formatDateTime(DateTime.now()),
              style: const TextStyle(
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
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Room',
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.business),
      //     //   label: 'Reservation',
      //     // ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.volunteer_activism),
      //       label: 'Lost & Found',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Color(0xFF27ae60),
      //   onTap: _onItemTapped,
      // ),
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
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    _searchController.addListener(_filterItems);
    // fatchEmployee();
    // reInit();
    print('check ini');
  }

  Map<String, dynamic>? dataUser;
  Future<void> fatchEmployee() async {
    final prefs = await SharedPreferences.getInstance();
    // final cookie = prefs.getString('session_cookie');
    // if (cookie == null) {
    //   throw Exception('No session cookie found. Please log in again.');
    // }
    final request = EmployeeDetailRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
    );
    final response = await requestEmployee(requestQuery: request);
    setState(() {
      if (response is List) {
        items = response.map((EmpData) {
          return {
            'name': EmpData['name']?.toString() ?? '',
            'cell_number': EmpData['cell_number']?.toString() ?? '',
            'first_name': EmpData['first_name']?.toString() ?? '',
            'employee_name': EmpData['employee_name']?.toString() ?? '',
            'prefered_email': EmpData['prefered_email']?.toString() ?? '',
          };
        }).toList();
        var targetItem = items.firstWhere(
            (item) => item['prefered_email'] == 'othkkontena@gmail.com');
        if (targetItem.isNotEmpty) {
          dataUser = targetItem;
          // Provider.of<AppState>(context, listen: false).setDataUser(targetItem);
        } else {
          print(
              'Data dengan prefered_email "othkkontena@gmail.com" tidak ditemukan.');
        }
      } else {
        throw Exception('Unexpected response format');
      }
      isLoading = false;
    });
  }

  reInit() {
    if (AppState().roomList.isNotEmpty) {
      setState(() {
        items = AppState().roomList.map((roomData) {
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
      });
    }
  }

  Future<void> fetchItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = RoomRequest(
        cookie: AppState().cookieData,
        fields: '["*"]',
        orderBy: 'room_type asc',
        limit: 200,
      );
      final response = await requestItem(requestQuery: request);
      setState(() {
        AppState().roomList = response;
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: const Text('Filter 1'),
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
                    title: const Text('Filter 2'),
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
                    title: const Text('Filter 3'),
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
                        backgroundColor: const Color(0xFF27ae60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply Filter',
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
    if (label == "OC") return theme.colorScheme.error;
    if (label == "OD") return theme.colorScheme.error;
    if (label == "VD") return theme.colorScheme.onSecondary;
    if (label == "VC") return theme.colorScheme.onSecondary;
    if (label == "VR") return theme.colorScheme.primary;
    if (label == "OOS") return theme.colorScheme.onPrimaryContainer;
    if (label == "OOO") return theme.colorScheme.onPrimaryContainer;
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
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterSheet,
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                    ? const Center(child: Text('No rooms found.'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final label = filteredItems[index]['status'];
                          final color = getColorForLabel(label);
                          final dataRm = filteredItems[index];

                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    '${filteredItems[index]['room_name']}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${filteredItems[index]['room_type_name']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      // Text(
                                      //   filteredItems[index]['name'] !=
                                      //           null // Change this as per your data
                                      //       ? filteredItems[index]['name']!
                                      //           .toString()
                                      //       : 'No Guest',
                                      //   textAlign: TextAlign.left,
                                      //   style: const TextStyle(
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 18),
                                      // ),
                                    ],
                                  ),
                                  onTap: () {
                                    String? fieldWithOne =
                                        getFirstFieldWithOneAtIndex(index);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailRoomPage(
                                          dataRoom: dataRm,
                                          title:
                                              '${filteredItems[index]['room_name']} - ${filteredItems[index]['room_type_name']}',
                                          data:
                                              '${filteredItems[index]['room_name']} - ${filteredItems[index]['room_type_name']}',
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
                                        style: const TextStyle(
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
