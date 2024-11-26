import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kontena_hk/functions/status_room_color.dart';
import 'package:kontena_hk/presentation/home_page/add_damage.dart';
import 'package:kontena_hk/presentation/lost_found_page/lost_found_add_page.dart';
import 'package:kontena_hk/routes/app_routes.dart';
import 'package:kontena_hk/utils/custom_button_style.dart';
import 'package:kontena_hk/utils/datetime.dart';
import 'package:kontena_hk/utils/theme.helper.dart';
import 'package:kontena_hk/widget/alert.dart';
import 'package:kontena_hk/widget/custom_outlined_button.dart';
import 'package:kontena_hk/app_state.dart';

import 'package:kontena_hk/api/data/room_api.dart' as call_room;
import 'package:kontena_hk/api/create_room_task.dart' as call_create_room_task;
import 'package:kontena_hk/api/room_task.dart' as call_room_task;
import 'package:kontena_hk/api/room_inspect.dart' as call_room_inspect;
import 'package:kontena_hk/api/create_room_inspect.dart'
    as call_create_room_inspect;

class DetailRoomPage extends StatefulWidget {
  final String data;
  final String title;
  final String status;
  final String detail;
  final dynamic dataRoom;

  const DetailRoomPage({
    required this.title,
    required this.data,
    required this.status,
    required this.detail,
    required this.dataRoom,
    super.key,
  });

  @override
  _DetailRoomPageState createState() => _DetailRoomPageState();
}

class _DetailRoomPageState extends State<DetailRoomPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late String nextStatus = 'OCCUPIED CLEANING';
  late String currentStatus;
  late String detail;
  String checkboxLabel = "";
  String employee = '';
  String purpose = '';

  dynamic dataRoom;

  bool isCheckboxVisible = false;
  bool isUpdateButtonEnabled = false;
  bool checkboxValue = false;
  bool isLoading = false;
  bool canClean = false;
  bool canCheck = false;
  bool isDamage = false;
  bool isOccupied = false;

  List<dynamic> dataRoomTask = [];
  List<dynamic> dataRoomInspect = [];

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
    detail = widget.detail;
    checkFieldsInDetail();
    onTapHistory();

    setState(() {
      employee = AppState().dataUser.containsKey('employee')
          ? AppState().dataUser['employee']['name']
          : '';
    });
    // print('check data, ${dataRoomTask[0]}');
  }

  checkFieldsInDetail() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 65,
        leading: Row(
          children: [
            SizedBox(width: 2.0), // Adjust the width as needed
            Align(
              alignment: Alignment.centerLeft, // Change the alignment as needed
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  onTapBackToHome();
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (dataRoomTask.isNotEmpty) {
              // print('checke, ${dataRoomTask[0]["employee_name"]}');
            }
            return (isLoading == false)
                ? SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: theme
                                              .colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        getStatus(dataRoom['room_status']),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: getColorForLabel(
                                              dataRoom['room_status']),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      if ((isLoading == false) &&
                                          (dataRoomTask.isNotEmpty))
                                        Text(
                                          'User is ${dataRoomTask[0]['purpose']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: theme
                                                .colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                      if ((isLoading == false) &&
                                          (dataRoomTask.isNotEmpty))
                                        const SizedBox(height: 2),
                                      if ((isLoading == false) &&
                                          (dataRoomTask.isNotEmpty))
                                        Text(
                                          dataRoomTask[0]['employee_name'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      if ((isLoading == false) &&
                                          (dataRoomTask.isNotEmpty))
                                        Text(
                                          "[ ${dataRoomTask[0]['employee']} ]",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      // const SizedBox(height: 5),
                                      // Text(
                                      //   getStatus(nextStatus),
                                      //   style: TextStyle(
                                      //     fontSize: 16,
                                      //     color: getColorForLabel(nextStatus),
                                      //     fontWeight: FontWeight.w600,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  // GestureDetector(
                                  //   onTap: _showReportDialog,
                                  //   child: const Icon(Icons.error_outline,
                                  //       color: Color(0xFFe74c3c)),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     const Text("Next Status",
                              //         style: TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.w500,
                              //             color: Color(0xFF2c3e50))),
                              //     Text(nextStatus,
                              //         style: const TextStyle(
                              //             fontSize: 16, color: Color(0xFF3498db))),
                              //   ],
                              // ),
                              const SizedBox(height: 24),
                              // if (isCheckboxVisible)
                              //   CheckboxListTile(
                              //     title: Text(checkboxLabel),
                              //     value: checkboxValue,
                              //     onChanged: (bool? value) {
                              //       setState(() {
                              //         checkboxValue = value ?? false;
                              //       });
                              //       updateButtonState();
                              //     },
                              //   ),
                              const Spacer(),
                              if ((isLoading == false) &&
                                  (dataRoomTask.isEmpty) &&
                                  (dataRoom['can_use'] == 0) &&
                                  (dataRoom['is_occupied'] == 0))
                                CustomOutlinedButton(
                                  height: 60.0,
                                  text: dataRoom['can_check'] == 1
                                      ? "Check Status"
                                      : "Update Status",
                                  isDisabled: false,
                                  buttonTextStyle: TextStyle(
                                    color: theme.colorScheme.primaryContainer,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  buttonStyle: CustomButtonStyles.primary,
                                  onPressed: () {
                                    // onTapPay(context);
                                    onTapUpdateStatus();
                                  },
                                ),
                              if ((isLoading == false) &&
                                  (dataRoomTask.isNotEmpty) &&
                                  (dataRoom['can_use'] == 0) &&
                                  (dataRoom['is_occupied'] == 0))
                                CustomOutlinedButton(
                                  height: 60.0,
                                  text: "Finish ${dataRoomTask[0]['purpose']}",
                                  isDisabled: false,
                                  buttonTextStyle: TextStyle(
                                    color: theme.colorScheme.primaryContainer,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  buttonStyle: CustomButtonStyles.primary,
                                  onPressed: () {
                                    // onTapPay(context);
                                    onTapUpdateStatus();
                                  },
                                ),

                              if (isLoading)
                                Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 8.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 23,
                                            height: 23,
                                            child:
                                                const CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10.0, 0.0, 8.0, 0.0),
                                          child: Text(
                                            'Loading...',
                                            style: TextStyle(
                                                color: theme.colorScheme
                                                    .primaryContainer),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 12),

                              if ((isLoading == false) &&
                                  (dataRoom['is_occupied'] == 0) &&
                                  (dataRoom['is_damaged'] != 1) &&
                                  (dataRoomTask.isEmpty))
                                CustomOutlinedButton(
                                  height: 60.0,
                                  text: "Maintenance",
                                  isDisabled: false,
                                  buttonTextStyle: TextStyle(
                                    color: theme.colorScheme.primaryContainer,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  buttonStyle: CustomButtonStyles.error,
                                  onPressed: () {
                                    onTapMaintenance();
                                  },
                                ),
                              if (isLoading)
                                Container(
                                  width: double.infinity,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 8.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: 23,
                                            height: 23,
                                            child:
                                                const CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10.0, 0.0, 8.0, 0.0),
                                          child: Text(
                                            'Loading...',
                                            style: TextStyle(
                                                color: theme.colorScheme
                                                    .primaryContainer),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        width: double.infinity,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            theme.colorScheme.primaryContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 8.0, 8.0, 8.0),
                                      child: Text(
                                        'Loading',
                                        style: TextStyle(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                        ),
                                      ),
                                    ),
                                  ],
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
    // final employee = appState().dataUser?['name'];
    // if (AppState().cookieData == null) {
    //   print('Cookie not found. Please log in again.');
    //   return;
    // }
    // final purpose = checkboxLabel;
    // try {
    //   CreateRoomTaskRequest request = CreateRoomTaskRequest(
    //     cookie: AppState().cookieData,
    //     purpose: purpose,
    //     room: widget.data,
    //     employee: employee,
    //     employeeName: '',
    //   );
    //   // final response = await requestRoomTask(requestQuery: request);
    //   print('Room task successfully created with purpose: $purpose');
    // } catch (e) {
    //   print('Failed to send status: $e');
    // }
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

  onCallRoomDetail() async {
    final call_room.RoomRequest requestCall = call_room.RoomRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      id: widget.dataRoom['name'],
    );

    try {
      final request = await call_room.detail(requestQuery: requestCall);
      if (request.isNotEmpty) {
        setState(() {
          // isLoading = false;
          dataRoom = request;
        });
      }
    } catch (error) {
      if (error is TimeoutException) {
        // Handle timeout error
        // _bottomScreenTimeout(context);
      } else {
        if (context.mounted) {
          alertError(context, error.toString());
        }
      }
      return;
    }
  }

  onCallRoomTask() async {
    final call_room_task.RoomTaskRequest request =
        call_room_task.RoomTaskRequest(
            cookie: AppState().cookieData,
            fields: '["name","purpose","employee","employee_name"]',
            filters:
                '[["docstatus","=",0],["room","=","${dataRoom['name']}"]]');

    try {
      final callRequest = await call_room_task.request(requestQuery: request);

      if (callRequest.isNotEmpty) {
        setState(() {
          dataRoomTask = callRequest;
        });
      } else {
        setState(() {
          dataRoomTask = [];
        });
      }
    } catch (error) {
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallCreateRoomTask() async {
    // final purpose = checkboxLabel;
    final call_create_room_task.CreateRoomTask request =
        call_create_room_task.CreateRoomTask(
      cookie: AppState().cookieData,
      purpose: purpose,
      room: dataRoom['name'],
      employee: employee,
      employeeName: AppState().dataUser['user']['full_name'],
      date: dataRoom['is_damaged'] == 1 ? dateTimeFormat('date', null) : null,
    );

    try {
      final response =
          await call_create_room_task.request(requestQuery: request);

      if (response.isNotEmpty) {
        setState(() {
          isLoading = false;
        });

        if (mounted) {
          alertSuccess(context, 'Successfully updated room status');
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallSubmitRoomTask() async {
    final purpose = checkboxLabel;
    final call_create_room_task.CreateRoomTask request =
        call_create_room_task.CreateRoomTask(
      cookie: AppState().cookieData,
      purpose: purpose,
      room: dataRoom['name'],
      employee: employee,
      employeeName: AppState().dataUser['user']['full_name'],
      id: dataRoomTask[0]['name'],
    );

    try {
      final response =
          await call_create_room_task.request(requestQuery: request);

      if (response.isNotEmpty) {
        setState(() {
          isLoading = false;
        });

        if (mounted) {
          alertSuccess(context, 'Successfully updated room status');
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('error create room task, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallRoomInspect() async {
    final call_room_inspect.RoomInspect request = call_room_inspect.RoomInspect(
        cookie: AppState().cookieData,
        fields: '["name","purpose"]',
        filters:
            '[["docstatus","=",0],["Room Inspect Detail","room","=","${dataRoom['name']}"]]');

    try {
      final callRequest =
          await call_room_inspect.request(requestQuery: request);
      print('room inspect, ${callRequest}');
      if (callRequest.isNotEmpty) {
        setState(() {
          dataRoomInspect = callRequest;
        });
      } else {
        setState(() {
          dataRoomInspect = [];
        });
      }
    } catch (error) {
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallCreateRoomInspect() async {
    final purpose = checkboxLabel;
    final call_create_room_inspect.CreateRoomInspect request =
        call_create_room_inspect.CreateRoomInspect(
      cookie: AppState().cookieData,
      purpose: purpose,
      date: dateTimeFormat('date', null).toString(),
      // statusCurrent: dataRoom['status'],
      // room: dataRoom['name'],
      roomInspect: [],
    );

    try {
      final response =
          await call_create_room_inspect.request(requestQuery: request);

      if (response.isNotEmpty) {
        setState(() {
          isLoading = false;
        });

        if (mounted) {
          alertSuccess(context, 'Successfully updated room status');
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('error create room task, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallRoom() async {
    final call_room.RoomRequest request = call_room.RoomRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      orderBy: 'room_type asc',
      limit: 200,
    );

    try {
      final callRequest = await call_room.requestItem(requestQuery: request);
      if (callRequest.isNotEmpty) {
        setState(() {
          AppState().roomList = callRequest;
        });
      }
    } catch (error) {
      if (mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCheckState() {
    if (dataRoom != null) {
      if (dataRoom.containsKey('can_clean')) {
        if (dataRoom['can_clean'] == 1) {
          canClean = true;
        } else {
          canClean = false;
        }
      }
      if (dataRoom.containsKey('can_check')) {
        if (dataRoom['can_check'] == 1) {
          canCheck = true;
        } else {
          canCheck = false;
        }
      }
      if (dataRoom.containsKey('is_damaged')) {
        if (dataRoom['is_damaged'] == 1) {
          isDamage = true;
        } else {
          isDamage = false;
        }
      }
      if (dataRoom.containsKey('is_occupied')) {
        if (dataRoom['is_occupied'] == 1) {
          isOccupied = true;
        } else {
          isOccupied = false;
        }
      }
    }
  }

  onTapHistory() async {
    setState(() {
      isLoading = true;
    });
    await onCallRoomDetail();
    await onCheckState();

    if (dataRoom != null) {
      if (isDamage) {
        setState(() {
          purpose = 'Maintain';
        });
      } else if (canCheck) {
        setState(() {
          purpose = 'Check';
        });
      } else {
        setState(() {
          purpose = 'Clean';
        });
      }

      if (dataRoom['is_damaged'] == 1) {
        print(1);
        await onCallRoomInspect();
        await onCallRoomTask();
      } else {
        print(2);
        await onCallRoomTask();
      }
    }

    await checkFieldsInDetail();
    setState(() {
      isLoading = false;
    });
  }

  onTapUpdateStatus() async {
    setState(() {
      isLoading = true;
    });
    if (dataRoomTask.isEmpty) {
      await onCallCreateRoomTask();
    } else {
      await onCallSubmitRoomTask();
    }
    await onTapHistory();

    setState(() {
      isLoading = false;
    });
  }

  onTapBackToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  onTapMaintenance() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        // dynamic editItem = {
        //   'id': item.id,
        //   'item_name': item.itemName,
        //   'notes': item.notes,
        //   'name': item.name,
        //   'qty': item.qty,
        //   'price': item.price,
        //   'uom': item.uom,
        //   'item_group': item.itemGroup,

        // 'variantPrice': item.variantPrice,
        // 'totalPrice': item.totalPrice,
        // 'addonsPrice': item.addonsPrice,
        // };

        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: CreateDamageWidget(
              room: dataRoom,
              onComplete: () {
                print('yes');
              }),
        );
      },
    ).then((value) => {});
    onTapHistory();
    setState(() {
      // cartData = cart.getAllItemCart();
    });
  }
}
