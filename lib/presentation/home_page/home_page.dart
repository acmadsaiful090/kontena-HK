import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kontena_hk/functions/status_room_color.dart';
import 'package:kontena_hk/presentation/home_page/detail_room_page.dart';
import 'package:kontena_hk/api/data/room_api.dart';
import 'package:kontena_hk/app_state.dart';
import 'package:kontena_hk/utils/datetime.dart';
import 'package:kontena_hk/utils/theme.helper.dart';
import 'package:kontena_hk/widget/bottom_navigation.dart';

// Import your pages
import 'package:kontena_hk/presentation/lost_found_page/lost_found_page.dart';
import 'package:kontena_hk/presentation/profile_page.dart/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
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

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Column(
          children: [
            Image.asset(
              'assets/image/kontena-hk.png',
              height: 45,
            ),
            Text(
              dateTimeFormat('dateMonthComplete', null).toString(),
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
      bottomNavigationBar: BottomNavigationCustom(
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
  const HomeContent({super.key});

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
  }

  Map<String, dynamic>? dataUser;
  Future<void> fatchEmployee() async {
    // final request = EmployeeDetailRequest(
    //   cookie: AppState().cookieData,
    //   fields: '["*"]',
    // );
    // final response = await requestEmployee(requestQuery: request);
    // setState(() {
    //   if (response is List) {
    //     items = response.map((EmpData) {
    //       return {
    //         'name': EmpData['name']?.toString() ?? '',
    //         'cell_number': EmpData['cell_number']?.toString() ?? '',
    //         'first_name': EmpData['first_name']?.toString() ?? '',
    //         'employee_name': EmpData['employee_name']?.toString() ?? '',
    //         'prefered_email': EmpData['prefered_email']?.toString() ?? '',
    //       };
    //     }).toList();
    //     var targetItem = items.firstWhere(
    //         (item) => item['prefered_email'] == 'othkkontena@gmail.com');
    //     if (targetItem.isNotEmpty) {
    //       dataUser = targetItem;
    //       // Provider.of<AppState>(context, listen: false).setDataUser(targetItem);
    //     } else {
    //       print(
    //           'Data dengan prefered_email "othkkontena@gmail.com" tidak ditemukan.');
    //     }
    //   } else {
    //     throw Exception('Unexpected response format');
    //   }
    //   isLoading = false;
    // });
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

  // String getRandomStatus() {
  //   List<String> status = ['OC', 'OD', 'VD', 'VC', 'VR'];
  //   return status[random.nextInt(5)];
  // }

  List<dynamic> roomList(List<dynamic> room, String search, String filter) {
    return room
        .where((rm) =>
            rm['name'].toString().toLowerCase().contains(search.toLowerCase()))
        .toList();
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
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme
                                .outline, // Warna border saat tidak aktif
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      suffixIcon: (_searchController.text != '')
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                    ),
                  ),
                ),
                // const SizedBox(width: 10),
                // if (_searchController.text != '')
                // IconButton(
                //   icon: const Icon(Icons.filter_list),
                //   onPressed: _showFilterSheet,
                // ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                    ? const Center(child: Text('No rooms found.'))
                    : Builder(builder: (context) {
                        final room =
                            roomList(filteredItems, _searchController.text, '');
                        return ListView.builder(
                          itemCount: room.length,
                          itemBuilder: (context, index) {
                            final roomItem = room[index];
                            // final dataRm = room[index];
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 0.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.outline,
                                        blurRadius: 5,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(
                                      '${roomItem['room_name']}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${roomItem['room_type_name']}',
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
                                            dataRoom: roomItem,
                                            title:
                                                '${roomItem['room_name']} - ${roomItem['room_type_name']}',
                                            data:
                                                '${roomItem['room_name']} - ${roomItem['room_type_name']}',
                                            status: roomItem['status'],
                                            detail: fieldWithOne ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    trailing: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: getColorForLabel(
                                            roomItem['status']),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          roomItem['status'],
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
                        );
                      }),
          ),
        ],
      ),
    );
  }
}
