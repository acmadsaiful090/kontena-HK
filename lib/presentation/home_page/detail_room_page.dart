import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kontena_hk/functions/status_room_color.dart';
import 'package:kontena_hk/presentation/home_page/add_damage.dart';
import 'package:kontena_hk/presentation/home_page/home_page.dart';
import 'package:kontena_hk/presentation/lost_found_page/lost_found_add_page.dart';
import 'package:kontena_hk/routes/app_routes.dart';
import 'package:kontena_hk/utils/custom_button_style.dart';
import 'package:kontena_hk/utils/datetime.dart';
import 'package:kontena_hk/utils/theme.helper.dart';
import 'package:kontena_hk/widget/alert.dart';
import 'package:kontena_hk/widget/custom_outlined_button.dart';
import 'package:kontena_hk/app_state.dart';

import 'package:kontena_hk/api/room_api.dart' as call_room;
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
  String employee = '';
  String purpose = '';

  dynamic dataRoom;

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
    onTapHistory();

    setState(() {
      employee = AppState().dataUser.containsKey('employee')
          ? AppState().dataUser['employee']['name']
          : '';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.secondary),
          onPressed: onTapBackToHome,
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return isLoading
                ? _buildLoadingWidget()
                : SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                              _buildRoomStatusSection(),
                              const Spacer(),
                              _buildActionButtons(),
                              const SizedBox(height: 12),
                              if (dataRoom['is_damaged'] != 1 &&
                                  dataRoomTask.isEmpty &&
                                  dataRoom['is_occupied'] == 0)
                                _buildMaintenanceButton(),
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

  Widget _buildRoomStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dataRoom['room_status'],
                  style: TextStyle(
                    fontSize: 20,
                    color: getColorForLabel(dataRoom['room_status']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                if (dataRoomTask.isNotEmpty) ...[
                  Text(
                    'User is ${dataRoomTask[0]['purpose']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dataRoomTask[0]['employee_name'],
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "[ ${dataRoomTask[0]['employee']} ]",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (dataRoomTask.isEmpty &&
        dataRoom['can_use'] == 0 &&
        dataRoom['is_occupied'] == 0) {
      return CustomOutlinedButton(
        height: 60.0,
        text: dataRoom['can_check'] == 1 ? "Check Status" : "Update Status",
        isDisabled: false,
        buttonTextStyle: TextStyle(
          color: theme.colorScheme.primaryContainer,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
        buttonStyle: CustomButtonStyles.primary,
        onPressed: onTapUpdateStatus,
      );
    }

    if (dataRoomTask.isNotEmpty &&
        dataRoom['can_use'] == 0 &&
        dataRoom['is_occupied'] == 0) {
      return CustomOutlinedButton(
        height: 60.0,
        text: "Finish ${dataRoomTask[0]['purpose']}",
        isDisabled: false,
        buttonTextStyle: TextStyle(
          color: theme.colorScheme.primaryContainer,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
        buttonStyle: CustomButtonStyles.primary,
        onPressed: onTapUpdateStatus,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMaintenanceButton() {
    return CustomOutlinedButton(
      height: 60.0,
      text: "Maintenance",
      isDisabled: false,
      buttonTextStyle: TextStyle(
        color: theme.colorScheme.primaryContainer,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      buttonStyle: CustomButtonStyles.error,
      onPressed: onTapMaintenance,
    );
  }

 Widget _buildLoadingWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 23,
          height: 23,
          child: const CircularProgressIndicator(),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: TextStyle(color: theme.colorScheme.primaryContainer),
        ),
      ],
    ),
  );
}


  onCallRoomDetail() async {
    final requestCall = call_room.RoomRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      id: widget.dataRoom['name'],
    );

    await _makeRequest(
      requestFunction: () => call_room.detail(requestQuery: requestCall),
      onSuccess: (data) => setState(() {
        dataRoom = data;
      }),
    );
  }

  onCallRoomTask() async {
    final request = call_room_task.RoomTaskRequest(
      cookie: AppState().cookieData,
      fields: '["name","purpose","employee","employee_name"]',
      filters:
          '[["docstatus","=",0],["room","=","${dataRoom['name']}"]]',
    );

    await _makeRequest(
      requestFunction: () => call_room_task.request(requestQuery: request),
      onSuccess: (data) => setState(() {
        dataRoomTask = data.isNotEmpty ? data : [];
      }),
    );
  }

  onCallCreateRoomTask() async {
    final request = call_create_room_task.CreateRoomTask(
      cookie: AppState().cookieData,
      purpose: purpose,
      room: dataRoom['name'],
      employee: employee,
      employeeName: AppState().dataUser['user']?['full_name'],
      date: dataRoom['is_damaged'] == 1 ? dateTimeFormat('date', null) : null,
    );

    await _makeRequest(
      requestFunction: () => call_create_room_task.request(requestQuery: request),
      onSuccess: (_) => _showAlert(context, "Successfully updated room status"),
    );
  }

  onCallSubmitRoomTask() async {
    final request = call_create_room_task.CreateRoomTask(
      cookie: AppState().cookieData,
      purpose: purpose,
      room: dataRoom['name'],
      employee: employee,
      employeeName: AppState().dataUser['user']?['full_name'],
      id: dataRoomTask[0]['name'],
    );

    await _makeRequest(
      requestFunction: () => call_create_room_task.request(requestQuery: request),
      onSuccess: (_) => _showAlert(context, "Successfully updated room status"),
    );
  }

  onCallRoomInspect() async {
    final request = call_room_inspect.RoomInspect(
      cookie: AppState().cookieData,
      fields: '["name","purpose"]',
      filters:
          '[["docstatus","=",0],["Room Inspect Detail","room","=","${dataRoom['name']}"]]',
    );

    await _makeRequest(
      requestFunction: () => call_room_inspect.request(requestQuery: request),
      onSuccess: (data) => setState(() {
        dataRoomInspect = data.isNotEmpty ? data : [];
      }),
    );
  }

  onCallCreateRoomInspect() async {
    final request = call_create_room_inspect.CreateRoomInspect(
      cookie: AppState().cookieData,
      purpose: purpose,
      date: dateTimeFormat('date', null).toString(),
      roomInspect: [],
    );

    await _makeRequest(
      requestFunction: () => call_create_room_inspect.request(requestQuery: request),
      onSuccess: (_) => _showAlert(context, "Successfully updated room status"),
    );
  }

  onCallRoom() async {
    final request = call_room.RoomRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      orderBy: 'room_type asc',
      limit: 200,
    );

    await _makeRequest(
      requestFunction: () => call_room.requestItem(requestQuery: request),
      onSuccess: (data) => setState(() {
        AppState().roomList = data;
      }),
    );
  }

  void onCheckState() {
    if (dataRoom == null) return;

    setState(() {
      canClean = dataRoom['can_clean'] == 1;
      canCheck = dataRoom['can_check'] == 1;
      isDamage = dataRoom['is_damaged'] == 1;
      isOccupied = dataRoom['is_occupied'] == 1;
    });
  }

  onTapHistory() async {
    setState(() => isLoading = true);

    await onCallRoomDetail();
    onCheckState();

    if (dataRoom != null) {
      setState(() {
        purpose = isDamage
            ? 'Maintain'
            : canCheck
                ? 'Check'
                : 'Clean';
      });

      if (isDamage) {
        await onCallRoomInspect();
      }
      await onCallRoomTask();
    }

    setState(() => isLoading = false);
  }

  onTapUpdateStatus() async {
    setState(() => isLoading = true);

    if (dataRoomTask.isEmpty) {
      await onCallCreateRoomTask();
      HomeContent.homeKey.currentState?.fetchItems();
    } else {
      await onCallSubmitRoomTask();
      HomeContent.homeKey.currentState?.fetchItems();
    }
    await onTapHistory();

    setState(() => isLoading = false);
  }

  void onTapBackToHome() {
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
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: CreateDamageWidget(
          room: dataRoom,
          onComplete: () => print("Maintenance complete"),
        ),
      ),
    );
    await onTapHistory();
    HomeContent.homeKey.currentState?.fetchItems();
  }

  _makeRequest({
    required Future<dynamic> Function() requestFunction,
    required Function(dynamic) onSuccess,
  }) async {
    try {
      final response = await requestFunction();
      if (response.isNotEmpty) {
        onSuccess(response);
      }
    } catch (error) {
      if (error is TimeoutException) {
        // Handle timeout
      } else if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  void _showAlert(BuildContext context, String message) {
    if (context.mounted) {
      alertSuccess(context, message);
    }
  }
}



//  onCallRoomDetail() async {
//     final call_room.RoomRequest requestCall = call_room.RoomRequest(
//       cookie: AppState().cookieData,
//       fields: '["*"]',
//       id: widget.dataRoom['name'],
//     );

//     try {
//       final request = await call_room.detail(requestQuery: requestCall);
//       if (request.isNotEmpty) {
//         setState(() {
//           // isLoading = false;
//           dataRoom = request;
//         });
//       }
//     } catch (error) {
//       if (error is TimeoutException) {
//         // Handle timeout error
//         // _bottomScreenTimeout(context);
//       } else {
//         if (context.mounted) {
//           alertError(context, error.toString());
//         }
//       }
//       return;
//     }
//   }
//   onCallRoomTask() async {
//     final call_room_task.RoomTaskRequest request =
//         call_room_task.RoomTaskRequest(
//             cookie: AppState().cookieData,
//             fields: '["name","purpose","employee","employee_name"]',
//             filters:
//                 '[["docstatus","=",0],["room","=","${dataRoom['name']}"]]');

//     try {
//       final callRequest = await call_room_task.request(requestQuery: request);

//       if (callRequest.isNotEmpty) {
//         setState(() {
//           dataRoomTask = callRequest;
//         });
//       } else {
//         setState(() {
//           dataRoomTask = [];
//         });
//       }
//     } catch (error) {
//       if (context.mounted) {
//         alertError(context, error.toString());
//       }
//     }
//   }

//   onCallCreateRoomTask() async {
//     final call_create_room_task.CreateRoomTask request =
//         call_create_room_task.CreateRoomTask(
//       cookie: AppState().cookieData,
//       purpose: purpose,
//       room: dataRoom['name'],
//       employee: employee,
//       employeeName: AppState().dataUser['user']['full_name'],
//       date: dataRoom['is_damaged'] == 1 ? dateTimeFormat('date', null) : null,
//     );

//     try {
//       final response =
//           await call_create_room_task.request(requestQuery: request);

//       if (response.isNotEmpty) {
//         setState(() {
//           isLoading = false;
//         });

//         if (mounted) {
//           alertSuccess(context, 'Successfully updated room status');
//         }
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       if (context.mounted) {
//         alertError(context, error.toString());
//       }
//     }
//   }

//   onCallSubmitRoomTask() async {
//     final call_create_room_task.CreateRoomTask request =
//         call_create_room_task.CreateRoomTask(
//       cookie: AppState().cookieData,
//       purpose: purpose,
//       room: dataRoom['name'],
//       employee: employee,
//       employeeName: AppState().dataUser['user']['full_name'],
//       id: dataRoomTask[0]['name'],
//     );

//     try {
//       final response =
//           await call_create_room_task.request(requestQuery: request);

//       if (response.isNotEmpty) {
//         setState(() {
//           isLoading = false;
//         });

//         if (mounted) {
//           alertSuccess(context, 'Successfully updated room status');
//         }
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       print('error create room task, ${error}');
//       if (context.mounted) {
//         alertError(context, error.toString());
//       }
//     }
//   }

//   onCallRoomInspect() async {
//     final call_room_inspect.RoomInspect request = call_room_inspect.RoomInspect(
//         cookie: AppState().cookieData,
//         fields: '["name","purpose"]',
//         filters:
//             '[["docstatus","=",0],["Room Inspect Detail","room","=","${dataRoom['name']}"]]');

//     try {
//       final callRequest =
//           await call_room_inspect.request(requestQuery: request);
//       print('room inspect, ${callRequest}');
//       if (callRequest.isNotEmpty) {
//         setState(() {
//           dataRoomInspect = callRequest;
//         });
//       } else {
//         setState(() {
//           dataRoomInspect = [];
//         });
//       }
//     } catch (error) {
//       if (context.mounted) {
//         alertError(context, error.toString());
//       }
//     }
//   }

//   onCallCreateRoomInspect() async {
//     final call_create_room_inspect.CreateRoomInspect request =
//         call_create_room_inspect.CreateRoomInspect(
//       cookie: AppState().cookieData,
//       purpose: purpose,
//       date: dateTimeFormat('date', null).toString(),
//       roomInspect: [],
//     );

//     try {
//       final response =
//           await call_create_room_inspect.request(requestQuery: request);

//       if (response.isNotEmpty) {
//         setState(() {
//           isLoading = false;
//         });

//         if (mounted) {
//           alertSuccess(context, 'Successfully updated room status');
//         }
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       print('error create room task, ${error}');
//       if (context.mounted) {
//         alertError(context, error.toString());
//       }
//     }
//   }

//   onCallRoom() async {
//     final call_room.RoomRequest request = call_room.RoomRequest(
//       cookie: AppState().cookieData,
//       fields: '["*"]',
//       orderBy: 'room_type asc',
//       limit: 200,
//     );

//     try {
//       final callRequest = await call_room.requestItem(requestQuery: request);
//       if (callRequest.isNotEmpty) {
//         setState(() {
//           AppState().roomList = callRequest;
//         });
//       }
//     } catch (error) {
//       if (mounted) {
//         alertError(context, error.toString());
//       }
//     }
//   }

//   onCheckState() {
//     if (dataRoom != null) {
//       if (dataRoom.containsKey('can_clean')) {
//         if (dataRoom['can_clean'] == 1) {
//           canClean = true;
//         } else {
//           canClean = false;
//         }
//       }
//       if (dataRoom.containsKey('can_check')) {
//         if (dataRoom['can_check'] == 1) {
//           canCheck = true;
//         } else {
//           canCheck = false;
//         }
//       }
//       if (dataRoom.containsKey('is_damaged')) {
//         if (dataRoom['is_damaged'] == 1) {
//           isDamage = true;
//         } else {
//           isDamage = false;
//         }
//       }
//       if (dataRoom.containsKey('is_occupied')) {
//         if (dataRoom['is_occupied'] == 1) {
//           isOccupied = true;
//         } else {
//           isOccupied = false;
//         }
//       }
//     }
//   }

//   onTapHistory() async {
//     setState(() {
//       isLoading = true;
//     });
//     await onCallRoomDetail();
//     await onCheckState();

//     if (dataRoom != null) {
//       if (isDamage) {
//         setState(() {
//           purpose = 'Maintain';
//         });
//       } else if (canCheck) {
//         setState(() {
//           purpose = 'Check';
//         });
//       } else {
//         setState(() {
//           purpose = 'Clean';
//         });
//       }

//       if (dataRoom['is_damaged'] == 1) {
//         print(1);
//         await onCallRoomInspect();
//         await onCallRoomTask();
//       } else {
//         print(2);
//         await onCallRoomTask();
//       }
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   onTapUpdateStatus() async {
//     setState(() {
//       isLoading = true;
//     });
//     if (dataRoomTask.isEmpty) {
//       await onCallCreateRoomTask();
//     } else {
//       await onCallSubmitRoomTask();
//     }
//     await onTapHistory();

//     setState(() {
//       isLoading = false;
//     });
//   }

//   onTapBackToHome() {
//     Navigator.of(context).pushNamedAndRemoveUntil(
//       AppRoutes.home,
//       (route) => false,
//     );
//   }

//   onTapMaintenance() async {
//     await showModalBottomSheet(
//       isScrollControlled: true,
//       enableDrag: false,
//       backgroundColor: const Color(0x8A000000),
//       barrierColor: const Color(0x00000000),
//       context: context,
//       builder: (context) {
//         // dynamic editItem = {
//         //   'id': item.id,
//         //   'item_name': item.itemName,
//         //   'notes': item.notes,
//         //   'name': item.name,
//         //   'qty': item.qty,
//         //   'price': item.price,
//         //   'uom': item.uom,
//         //   'item_group': item.itemGroup,

//         // 'variantPrice': item.variantPrice,
//         // 'totalPrice': item.totalPrice,
//         // 'addonsPrice': item.addonsPrice,
//         // };

//         return Padding(
//           padding: MediaQuery.viewInsetsOf(context),
//           child: CreateDamageWidget(
//               room: dataRoom,
//               onComplete: () {
//                 print('yes');
//               }),
//         );
//       },
//     ).then((value) => {});
//     onTapHistory();
//     setState(() {
//       // cartData = cart.getAllItemCart();
//     });
//   }
// }