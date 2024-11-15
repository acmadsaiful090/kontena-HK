import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jc_housekeeping/api/data/room_task_api.dart';
import 'package:jc_housekeeping/presentation/lost_found_page/lost_found_add_page.dart';
import 'package:jc_housekeeping/api/data/room_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jc_housekeeping/app_state.dart';
import 'package:provider/provider.dart';

class DetailRoomPage extends StatefulWidget {
  final String data;
  final String status;
  final String detail;

  const DetailRoomPage({
    required this.data,
    required this.status,
    required this.detail,
    Key? key,
  }) : super(key: key);

  @override
  _DetailRoomPageState createState() => _DetailRoomPageState();
}

class _DetailRoomPageState extends State<DetailRoomPage> {
  late String nextStatus = 'OCCUPIED CLEANING';
  late String currentStatus;
  late String detail;
  bool isCheckboxVisible = false;
  bool isUpdateButtonEnabled = false;
  String checkboxLabel = "";
  bool checkboxValue = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
    detail = widget.detail;
    checkFieldsInDetail();
  }

  void checkFieldsInDetail() {
    if (detail.contains('can_clean')) {
      checkboxLabel = 'Clean';
      isCheckboxVisible = true;
    } else if (detail.contains('can_check')) {
      checkboxLabel = 'Check';
      isCheckboxVisible = true;
    } else if (detail.contains('is_damaged')) {
      checkboxLabel = 'Damage';
      isCheckboxVisible = true;
    } else {
      isCheckboxVisible = false;
    }
  }

  void updateButtonState() {
    setState(() {
      isUpdateButtonEnabled = checkboxValue;
    });
  }

  String getStatus() {
    switch (currentStatus) {
      case "OD":
        return "OCCUPIED_DIRTY";
      case "OC":
        return "OCCUPIED_CLEANING";
      case "VD":
        return "VACANT_DIRTY";
      case "VC":
        return "VACANT_CLEANING";
      case "VR":
        return "VACANT_READY";
      default:
        return currentStatus;
    }
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
                    children: [
                      Text(
                        widget.data,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF34495e),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Current State:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2c3e50),
                                  )),
                              const SizedBox(height: 5),
                              Text(getStatus(),
                                  style: const TextStyle(
                                      fontSize: 16, color: Color(0xFF7f8c8d))),
                            ],
                          ),
                          GestureDetector(
                            onTap: _showReportDialog,
                            child: const Icon(Icons.error_outline,
                                color: Color(0xFFe74c3c)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Next Status",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2c3e50))),
                          Text(nextStatus,
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0xFF3498db))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (isCheckboxVisible)
                        CheckboxListTile(
                          title: Text(checkboxLabel),
                          value: checkboxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxValue = value ?? false;
                            });
                            updateButtonState();
                          },
                        ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF27ae60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: isUpdateButtonEnabled
                              ? _showUpdateStatusDialog
                              : null,
                          child: const Text('Update Status',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) {
        return _buildBottomSheet(
          title: 'Choose Next Status',
          options: [
            {'label': 'OCCUPIED_DIRTY', 'color': Colors.orange},
            {'label': 'VACANT_DIRTY', 'color': Colors.red},
          ],
          onSelect: (status) => _showConfirmationDialog(status),
        );
      },
    );
  }

  void _showConfirmationDialog(String status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Change status to $status?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => nextStatus = status);
                _sendStatusRequest();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _sendStatusRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('session_cookie');
    final appState = Provider.of<AppState>(context, listen: false);
    final employee = appState.dataUser?['name'];
    if (cookie == null) {
      print('Cookie not found. Please log in again.');
      return;
    }
    final purpose = checkboxLabel;
    try {
      CreateRoomTaskRequest request = CreateRoomTaskRequest(
        cookie: cookie,
        purpose: purpose,
        room: widget.data,
        employee: employee,
      );
      final response = await requestRoomTask(requestQuery: request);
      print('Room task successfully created with purpose: $purpose');
    } catch (e) {
      print('Failed to send status: $e');
    }
  }

  void _showReportDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) {
        return _buildBottomSheet(
          title: 'Report',
          options: [
            {
              'label': 'Lost & Found',
              'icon': Icons.volunteer_activism,
              'color': Colors.green,
              'onTap': () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LostFoundAddPage()))
            },
            {
              'label': 'Do not disturb',
              'icon': Icons.do_not_disturb,
              'color': Colors.red
            },
          ],
        );
      },
    );
  }

  Widget _buildBottomSheet(
      {required String title,
      required List<Map<String, dynamic>> options,
      Function(String)? onSelect}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...options.map((option) => ListTile(
                leading: Icon(option['icon'] ?? Icons.brightness_1,
                    color: option['color']),
                title: Text(option['label']),
                onTap: option['onTap'] ?? () => onSelect?.call(option['label']),
              )),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
