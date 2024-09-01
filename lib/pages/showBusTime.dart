import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:json/classes/secureStorage.dart';
import 'package:json/models/envioment.dart';
import 'package:json/pages/createUpdateBusTime.dart';
import 'package:json/themes/customColors.dart';
import 'package:json/widgets/elevatedButton.dart';
import 'package:json/utils/utils.dart';
import 'package:json/widgets/customAppBar.dart';
import 'package:json/widgets/customText.dart';

class ShowBustime extends StatefulWidget {
  const ShowBustime({super.key});

  @override
  State<ShowBustime> createState() => _ShowBustimeState();
}

class _ShowBustimeState extends State<ShowBustime>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<dynamic> response = [];
  int? selectedIndex;

  @override
  void initState() {
    readBusTimeList();

    // Initialize the animation controller
    _controller = AnimationController(
      duration:
          const Duration(milliseconds: 1250), // Animation duration of 1 second
      vsync: this,
    );

    // Define the bounce animation using CurvedAnimation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth transition up and down
    );

    // Start the animation with a periodic timer
    Timer.periodic(const Duration(seconds: 7), (timer) {
      _controller.forward().then((_) => _controller.reverse());
    });

    super.initState();
  }

  void readBusTimeList() async {
    final data =
        (await SecureStorage().readLoginCredentials(Enviroment.busTimeList))
            .value;
    debugPrint('Function response = ${data.runtimeType}');
    setState(() {
      response = jsonDecode(data);
    });
    for (int i = 0; i < response.length; i++) {
      debugPrint('response = ${response[i]}');
    }
  }

  void delete(int index) {
    selectedIndex = index;
    response.removeAt(selectedIndex!);
    final encodedList = jsonEncode(response);
    SecureStorage().writeLoginCredentials(Enviroment.busTimeList, encodedList);
    Utils().toastMessage(
        'Data deleted successfully', ToastGravity.TOP, Colors.red);
    readBusTimeList();
  }

  void sortingDateTime() {
    List<String> dateStrings = [
      '2081-09-01 10:30 AM',
      '2081-09-01 08:15 PM',
      '2081-08-31 12:45 PM',
      '2081-09-01 09:50 AM',
    ];

    // Define the date format used in the strings
    DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm a');

    // Sort the list
    dateStrings.sort((a, b) {
      DateTime dateA = dateFormat.parse(a);
      DateTime dateB = dateFormat.parse(b);
      return dateA.compareTo(dateB);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              elevation: 10,
              title: CustomText(
                text: 'Exit',
                fontWeight: FontWeight.bold,
                size: 24.0,
                color: Colors.red,
              ),
              content: CustomText(
                text: 'Are you sure you want to exit ?',
                fontWeight: FontWeight.w500,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      // backgroundColor: Colors.green,
                      borderColor: CustomColors.primaryColor,
                      widget: CustomText(
                        text: 'No',
                        fontWeight: FontWeight.w500,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      // backgroundColor: Colors.red,
                      borderColor: Colors.red,
                      widget: CustomText(
                        text: 'Yes',
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(
            tabName: 'Bus Time',
            isShowCard: false,
            showTrailingIcons: true,
            showPopupMenu: true,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 16.0, bottom: 40.0),
          child: ListView.builder(
            itemCount: response.length,
            itemBuilder: (context, index) {
              Color cardColor = Colors.white;
              Color iconColor = CustomColors.primaryColor;
              Color textColor = Colors.black;
              Color dividerColor = Colors.black;
              int count = index;
              if ((++count).isEven) {
                cardColor = CustomColors.primaryColor;
                iconColor = Colors.black;
                textColor = const Color(0xffF8F9Fa);
                dividerColor = Colors.black;
              }
              return ListTile(
                title: Stack(
                  children: [
                    Card(
                      color: cardColor,
                      margin: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 0.0,
                      ),
                      elevation: 3.0,
                      shadowColor: Colors.black,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          top: 10.0,
                          bottom: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text:
                                      '${response[index]['name'].toString().capitalizeFirst}',
                                  size: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ],
                            ),
                            Divider(
                              color: dividerColor,
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text:
                                          '${response[index]['departureFrom'].toString().capitalizeFirst}',
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                    CustomText(
                                      text: response[index]['departureTime']
                                          .toString()
                                          .replaceFirst('T', ' '),
                                      size: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ],
                                ),
                                Image(
                                  width: 48,
                                  height: 24.0,
                                  color: iconColor,
                                  image: const AssetImage(
                                      'assets/images/travel.png'),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text:
                                          '${response[index]['destination'].toString().capitalizeFirst}',
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                    CustomText(
                                      text: response[index]['arrivalTime']
                                          .toString()
                                          .replaceFirst('T', ' '),
                                      size: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: PopupMenuButton(
                        // constraints: BoxConstraints.loose(Size(8.0, 8.0)),
                        position: PopupMenuPosition.under,
                        iconSize: 24.0,
                        iconColor: iconColor,
                        color: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: CustomText(text: 'Edit'),
                              onTap: () {
                                debugPrint('id = ${response[index]}');
                                debugPrint('index = $index');
                                Get.off(MyHomePage(
                                  crudOperation: 'Edit',
                                  crudOpEdit: true,
                                  index: index,
                                  busNumber:
                                      response[index]['busNumber'].toString(),
                                  busName: response[index]['name'].toString(),
                                  departure: response[index]['departureFrom']
                                      .toString(),
                                  arrival:
                                      response[index]['destination'].toString(),
                                  departureTime: response[index]
                                          ['departureTime']
                                      .toString(),
                                  arrivalTime:
                                      response[index]['arrivalTime'].toString(),
                                ));
                              },
                            ),
                            PopupMenuItem(
                              onTap: () {
                                delete(index);
                              },
                              child: CustomText(text: 'Delete'),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_animation.value * 50),
              child: Transform.scale(
                scale: 1 + (_animation.value * 0.20),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: CustomColors.primaryColor,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    // SecureStorage().writeLoginCredentials(Enviroment.id, '1');
                    Get.off(const MyHomePage(crudOperation: 'Create'));
                  },
                  child: Icon(
                    Icons.add,
                    size: 28 + (_animation.value * 5),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
