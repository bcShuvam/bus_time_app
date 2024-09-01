import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json/classes/secureStorage.dart';
import 'package:json/models/envioment.dart';
import 'package:json/models/jsonModel.dart';
import 'package:json/pages/showBusTimeTable.dart';
import 'package:json/pages/showBusTime.dart';
import 'package:json/themes/customColors.dart';
import 'package:json/widgets/elevatedButton.dart';
import 'package:json/utils/utils.dart';
import 'package:json/widgets/customAppBar.dart';
import 'package:json/widgets/customText.dart';
import 'package:json/widgets/inputFormField.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.crudOperation,
    this.crudOpEdit = false,
    this.index,
    this.busName = '',
    this.busNumber = '',
    this.departure = '',
    this.arrival = '',
    this.departureTime = '',
    this.arrivalTime = '',
  });
  final String crudOperation;
  final bool crudOpEdit;
  final int? index;
  final String busName;
  final String busNumber;
  final String departure;
  final String arrival;
  final String departureTime;
  final String arrivalTime;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final json = const JsonCodec();
  int id = 0;
  int? index;
  List<dynamic> response = [];

  final busNameController = TextEditingController();
  final busNumberController = TextEditingController();
  final departureController = TextEditingController();
  final arrivalController = TextEditingController();
  final dateController = TextEditingController();
  final departureTimeController = TextEditingController();
  final arrivalTimeController = TextEditingController();

  String data = '';
  NepaliDateTime nepaliDateTime = NepaliDateTime.now();
  NepaliDateFormat yearMonthDateBSFormat = NepaliDateFormat('yyyy-MM-dd G');
  NepaliDateTime selectedDate = NepaliDateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    readData();
    debugPrint('$NepaliDateTime');
    String formattedDate = NepaliDateFormat('yyyy-MM-dd')
        .format(nepaliDateTime)
        .toString()
        .padLeft(2, '0');
    int hour = nepaliDateTime.hour;
    int minute = nepaliDateTime.minute;
    // Determine AM or PM
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert hour to 12-hour format and apply padding
    hour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    String formattedHour = hour.toString().padLeft(2, '0');

    // Apply padding to minutes
    String formattedMinute = minute.toString().padLeft(2, '0');
    // Format the time part using .jm() for 12-hour format with AM/PM
    // Combine hour, minute, and period to get the formatted time
    String formattedTime = '$formattedHour:$formattedMinute $period';
    dateController.text = '$formattedDate $formattedTime';
    index = widget.index;
    busNumberController.text = widget.busNumber;
    busNameController.text = widget.busName;
    departureController.text = widget.departure;
    arrivalController.text = widget.arrival;
    departureTimeController.text = widget.departureTime;
    arrivalTimeController.text = widget.arrivalTime;
    super.initState();
  }

  void readData() async {
    final data =
        (await SecureStorage().readLoginCredentials(Enviroment.busTimeList))
            .value;
    final sn =
        (await SecureStorage().readLoginCredentials(Enviroment.id)).value;
    debugPrint(
        'JsonModel.id = ${(await SecureStorage().readLoginCredentials(Enviroment.id)).value}');
    setState(() {
      response = jsonDecode(data);
      id = int.parse(sn);
      debugPrint('id = $id');
    });
  }

  void updateBusTimeList() {
    response[index!]['busNumber'] = busNumberController.value.text;
    response[index!]['name'] = busNameController.value.text;
    response[index!]['departureFrom'] = departureController.value.text;
    response[index!]['destination'] = arrivalController.value.text;
    response[index!]['departureTime'] = departureTimeController.value.text;
    response[index!]['arrivalTime'] = arrivalTimeController.value.text;
    final encodeList = json.encode(response);
    SecureStorage().writeLoginCredentials(Enviroment.busTimeList, encodeList);
    Utils().toastMessage('Updated successfully');
    Get.off(const ShowBustime());
  }

  void heading(String text) {
    final starLineBuffer = StringBuffer();
    final padStringBuffer = StringBuffer();
    final padding = (40 - text.length) ~/ 2;

    starLineBuffer.writeAll([for (var i = 0; i < 40; i++) '*']);
    padStringBuffer.writeAll([for (var i = 0; i < padding; i++) ' ']);

    print(starLineBuffer);
    print(padStringBuffer.toString() + text + padStringBuffer.toString());
    print(starLineBuffer);
  }

  void create() async {
    readData();
    String currentDateTime =
        NepaliDateFormat('yyyy-MM-dd hh:mm aa').format(NepaliDateTime.now());
    debugPrint('currentDateTime $currentDateTime');
    debugPrint(
        'JsonModel.id = ${(await SecureStorage().readLoginCredentials(Enviroment.id)).value}');
    setState(() {
      JsonModel.busTimeList = {};
      JsonModel.addBusTime(
        ++id,
        busNumberController.value.text,
        busNameController.value.text,
        departureController.value.text,
        arrivalController.value.text,
        currentDateTime,
        departureTimeController.value.text,
        arrivalTimeController.value.text,
      );
      response.add(JsonModel.getBusTimeList());
      debugPrint('response = $response');
      final encodeList = json.encode(response);
      SecureStorage().writeLoginCredentials(Enviroment.id, '$id');
      SecureStorage().writeLoginCredentials(Enviroment.busTimeList, encodeList);
      Get.off(const DataTablePage());
    });
  }

  Future<String?> datePicker() async {
    String date = '';
    NepaliDateTime? _selectedDateTime = await picker.showMaterialDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              surfaceContainerHighest: Colors.white,
              tertiary: CustomColors.primaryColor,
              onTertiary: Colors.white,
              primary: CustomColors.primaryColor, // circle color
              onPrimary: Colors.white, // selected text color
              onSurface: CustomColors.primaryColor, // default text color
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.primaryColor,
                textStyle: TextStyle(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  // fontFamily: 'Quicksand',
                ), // color of button's letters
                // backgroundColor: Colors.green, // Background color
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: CustomColors.primaryColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    // selectedDate = _selectedDateTime!;
    if (_selectedDateTime != null) {
      setState(() {
        selectedDate = _selectedDateTime;
        date = _selectedDateTime.toString().split(' ')[0];
        debugPrint('departureController.text = ${departureController.text}');
        debugPrint('selectedDate = $date');
      });
      return date;
    }
    return date;
  }

  Future<String> timePicker() async {
    String selectedTime = '';
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                surfaceContainerHighest: Colors.white,
                tertiary: CustomColors.primaryColor,
                onTertiary: Colors.white,
                primary: CustomColors.primaryColor, // circle color
                onPrimary: Colors.white, // selected text color
                onSurface: CustomColors.primaryColor, // default text color
              ),
              // dialogBackgroundColor: Colors.black,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: CustomColors.primaryColor,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ), // color of button's letters
                  // backgroundColor: Colors.green, // Background color
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: CustomColors.primaryColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (pickedTime != null) {
      timeOfDay = pickedTime;
      setState(() {
        final int hour =
            pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
        final String formattedHour = hour.toString().padLeft(2, '0');
        final String formattedMinute =
            pickedTime.minute.toString().padLeft(2, '0');
        final String period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
        // Set the formatted time to the text controller
        selectedTime = 'T$formattedHour:$formattedMinute $period';
        debugPrint('selectedTime = $selectedTime');
      });
      return selectedTime;
    }
    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Get.off(const ShowBustime());
      }),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(
            tabName: '${widget.crudOperation} Bus Time',
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2.0,
                        blurRadius: 10.0,
                        offset: const Offset(3, 3),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomInputFormField(
                        textController: busNumberController,
                        labelText: 'Bus Number',
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Bus numbre is required'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomInputFormField(
                        textController: busNameController,
                        labelText: 'Bus Name',
                        validator: (value) {
                          return value!.isEmpty ? 'Bus name is required' : null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomInputFormField(
                        textController: departureController,
                        labelText: 'Departure From',
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Departure from is required'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomInputFormField(
                        textController: arrivalController,
                        labelText: 'Arrive To',
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Arrive To is required'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomInputFormField(
                        readOnly: true,
                        textController: dateController,
                        labelText: 'Date',
                        validator: (value) {
                          return value!.isEmpty ? 'Date is required' : null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomInputFormField(
                        textController: departureTimeController,
                        labelText: 'Departure Time',
                        readOnly: true,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Departure time is required'
                              : null;
                        },
                        onTap: () async {
                          String? date = await datePicker();
                          String? time = await timePicker();
                          setState(() {
                            departureTimeController.text = '$date$time';
                          });
                          // await Future.delayed(const Duration(seconds: 1));
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomInputFormField(
                        textController: arrivalTimeController,
                        labelText: 'Arrival Time',
                        readOnly: true,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Arrival time is required'
                              : null;
                        },
                        onTap: () async {
                          String? date = await datePicker();
                          String? time = await timePicker();
                          setState(() {
                            arrivalTimeController.text = '$date$time';
                          });
                          // await Future.delayed(const Duration(seconds: 1));
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomElevatedButton(
                            onPressed: () {
                              Get.off(const ShowBustime());
                            },
                            borderColor: Colors.red,
                            widget: CustomText(
                              text: 'Cancel',
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          widget.crudOpEdit
                              ? CustomElevatedButton(
                                  onPressed: updateBusTimeList,
                                  // backgroundColor: Colors.green,
                                  borderColor: CustomColors.primaryColor,
                                  widget: CustomText(
                                    text: 'Update',
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primaryColor,
                                  ),
                                )
                              : CustomElevatedButton(
                                  onPressed: () {
                                    debugPrint(
                                        '_formKey.currentState!.validate() = ${_formKey.currentState!.validate()}');
                                    if (_formKey.currentState!.validate()) {
                                      create();
                                    }
                                  },
                                  // backgroundColor: Colors.green,
                                  borderColor: CustomColors.primaryColor,
                                  widget: CustomText(
                                    text: 'Create',
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primaryColor,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
