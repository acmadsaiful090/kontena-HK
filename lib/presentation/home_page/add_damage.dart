import 'package:flutter/material.dart';
import 'package:jc_housekeeping/app_state.dart';
import 'package:jc_housekeeping/utils/datetime.dart';
import 'package:jc_housekeeping/utils/theme.helper.dart';
import 'package:jc_housekeeping/api/create_room_inspect.dart'
    as createRoomInspect;
import 'package:jc_housekeeping/widget/alert.dart';

class CreateDamageWidget extends StatefulWidget {
  final dynamic room;
  final VoidCallback? onComplete;

  CreateDamageWidget({Key? key, this.room, this.onComplete,}) : super(key: key);

  @override
  _CreateDamageWidgetState createState() => _CreateDamageWidgetState();
}

class _CreateDamageWidgetState extends State<CreateDamageWidget> {
  TextEditingController date = TextEditingController();
  TextEditingController room = TextEditingController();
  TextEditingController currentStatus = TextEditingController();
  TextEditingController untilDate = TextEditingController();

  bool isLoading = false;

  String datePick = '';

  List<dynamic> typeDamage = [
    {'value': 'OOO', 'text': 'Out Of Order'},
    {'value': 'OOS', 'text': 'Out Of Service'}
  ];

  dynamic selectedType;

  @override
  void initState() {
    super.initState();

    if (widget.room != null) {
      room.text = widget.room['name'];
      currentStatus.text = widget.room['room_status'];
    }
    // room.text =
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                height: MediaQuery.sizeOf(context).height * 0.7,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Text(
                              'Create Room to Maintenance',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.of(context).pop(false);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 16.0, 16.0, 16.0),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: theme.colorScheme.secondary,
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: theme.colorScheme.outline,
                    ),
                    Expanded(
                      // width: double.infinity,
                      // height: 48.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 6.0, 16.0, 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Type ',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ]
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  // width: 280.0,
                                  height: 51.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: const Text("Select an Option"),
                                        value: selectedType,
                                        items: typeDamage.map((dynamic data) {
                                          return DropdownMenuItem<String>(
                                            value: data['value'],
                                            child: Text(
                                              "${data['value']} - ${data['text']}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedType = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 6.0, 16.0, 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Date ',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ]
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  // width: 280.0,
                                  height: 51.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: date,
                                    decoration: InputDecoration(
                                      hintText: 'Pick a Date',
                                      hintStyle: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 14.0,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.white,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      // Open date picker
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );

                                      if (pickedDate != null) {
                                        // Format and set the selected date
                                        setState(() {
                                          datePick = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                          date.text =
                                              "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 6.0, 16.0, 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Room ',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ]
                                ),
                                
                                const SizedBox(height: 6.0),
                                Container(
                                  // width: 280.0,
                                  height: 51.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: room,
                                    decoration: InputDecoration(
                                      hintText: 'Room',
                                      hintStyle: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 14.0,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.white,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 6.0, 16.0, 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Current Status ',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ]
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  // width: 280.0,
                                  height: 51.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: currentStatus,
                                    decoration: InputDecoration(
                                      hintText: 'Status',
                                      hintStyle: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 14.0,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.white,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 6.0, 16.0, 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Until Date',
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  // width: 280.0,
                                  height: 51.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: untilDate,
                                    decoration: InputDecoration(
                                      hintText: 'Pick a Date',
                                      hintStyle: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 14.0,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.white,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      // Open date picker
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );

                                      if (pickedDate != null) {
                                        // Format and set the selected date
                                        setState(() {
                                          untilDate.text =
                                              "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: theme.colorScheme.outline,
                    ),
                    //  Expanded(
                    //     child: 
                    if (isLoading == false)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            8.0, 8.0, 8.0, 8.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            // onTapDone(context);
                            // onTapSave(context);
                            onTapSubmit();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            alignment:
                                const AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      4.0, 4.0, 4.0, 4.0),
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      theme.colorScheme.primaryContainer,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            8.0, 8.0, 8.0, 8.0),
                        child: Container(
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
                      ),
                      // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onTapSubmit() async {
    setState((){
      isLoading = true;
    });
    await onCallCreateRoomInspect();
    setState((){
      isLoading = false;
    });
  }

  onCallCreateRoomInspect() async {
    List<dynamic> detail = [];
    detail.add({
      'room': room.text,
      'status_current': currentStatus.text,
      'status_next': selectedType,
      'until': untilDate.text,
    });

    
    print('check date, ${date.text}');
    print('check date, ${dateTimeFormat('date', datePick)}');
    final createRoomInspect.CreateRoomInspect request = createRoomInspect.CreateRoomInspect(
      cookie: AppState().cookieData,
      purpose: 'Damage',
      date: datePick,
      roomInspect: detail,
    );

    try {
      print('check, ${request}');
      final callRequest = await createRoomInspect.request(requestQuery: request);
      if (callRequest.isNotEmpty) {
        if (mounted) {
          alertSuccess(context, 'Success, create room to maintence');
          widget.onComplete;
          Navigator.pop(context);
        }
      }
    } catch (error) {
      if (mounted) {
        alertError(context, error.toString());
      }
    }
  }
}
