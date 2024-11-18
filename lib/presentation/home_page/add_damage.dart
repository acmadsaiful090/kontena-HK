import 'package:flutter/material.dart';
import 'package:jc_housekeeping/utils/theme.helper.dart';

class CreateDamageWidget extends StatefulWidget {
  final dynamic room;
  CreateDamageWidget({Key? key, this.room}) : super(key: key);

  @override
  _CreateDamageWidgetState createState() => _CreateDamageWidgetState();
}

class _CreateDamageWidgetState extends State<CreateDamageWidget> {
  TextEditingController date = TextEditingController();
  TextEditingController room = TextEditingController();
  TextEditingController currentStatus = TextEditingController();

  bool isLoading = false;

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
                height: MediaQuery.sizeOf(context).height * 0.5,
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
                                Text(
                                  'Type',
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
                                Text(
                                  'Date',
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
                                Text(
                                  'Room',
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
                                Text(
                                  'Current Status',
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
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: theme.colorScheme.outline,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
