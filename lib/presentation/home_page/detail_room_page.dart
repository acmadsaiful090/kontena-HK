import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kontena_hk/presentation/lost_found_page/lost_found_add_page.dart';

class DetailRoomPage extends StatefulWidget {
  final String data;
  final String status;

  DetailRoomPage({required this.data, required this.status });

  @override
  _DetailRoomPageState createState() => _DetailRoomPageState();
}

class _DetailRoomPageState extends State<DetailRoomPage> {
  late String nextStatus = 'OCCUPIED CLEANING';
  late String currentStatus = widget.status;

  String getStatus() {
    if(currentStatus == "OD") return "OCCUPIED_DIRTY";
    if(currentStatus == "OC") return "OCCUPIED_CLEANING";
    if(currentStatus == "VD") return "VACANT_DIRTY";
    if(currentStatus == "VC") return "VACANT_CLEANING";
    if(currentStatus == "VR") return "VACANT_READY";
    return currentStatus;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.data,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF34495e),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current State:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2c3e50),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  getStatus(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF7f8c8d),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2),
                          GestureDetector(
                            onTap: () {
                              _showReportDialog();
                            },
                            child: Icon(
                              Icons.error_outline,
                              color: Color(0xFFe74c3c),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Next Status",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2c3e50),
                            ),
                          ),
                          Text(
                            nextStatus,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3498db),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
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
                            _showUpdateStatusDialog();
                          },
                          child: Text(
                            'Update Status',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateStatusDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Next Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.brightness_1, color: Colors.orange),
                title: Text('OCCUPIED_DIRTY'),
                onTap: () {
                  _showConfirmationDialog('OCCUPIED_DIRTY');
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_1, color: Colors.red),
                title: Text('VACANT_DIRTY'),
                onTap: () {
                  _showConfirmationDialog('VACANT_DIRTY');
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
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
  }

  void _showConfirmationDialog(String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Change status to $status?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {
                  nextStatus = status;
                });
                print("Status updated to $status");
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.volunteer_activism, color: Colors.green),
                title: Text('Lost & Found'),
                onTap: () {
                  print('Lost & Found reported');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LostFoundAddPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.do_not_disturb, color: Colors.red),
                title: Text('Do not disturb'),
                onTap: () {
                  print('Do not disturb reported');
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
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
  }
}
