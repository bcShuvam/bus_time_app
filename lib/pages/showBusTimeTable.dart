import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:json/classes/secureStorage.dart';
import 'package:json/models/envioment.dart';
import 'package:json/pages/createUpdateBusTime.dart';
import 'package:json/themes/customColors.dart';
import 'package:json/widgets/elevatedButton.dart';
import 'package:json/utils/utils.dart';
import 'package:json/widgets/customAppBar.dart';
import 'package:json/widgets/customText.dart';

class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<dynamic> response = [];
  FontWeight dataColumnFontWeight = FontWeight.w500;
  FontWeight dataCellFontWeight = FontWeight.w500;
  double dataColumnFontSize = 18.0;
  double dataCellFontSize = 16.0;
  Color dataColumnTextColor = Colors.white;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(
            tabName: 'Bus Time',
            isShowCard: true,
            showTrailingIcons: true,
            showPopupMenu: true,
          ),
        ),
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.only(
                  top: 24.0, bottom: 56.0, left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: DataTable(
                // showBottomBorder: true,
                headingRowHeight: 48.0,
                dataRowHeight: 40.0,
                dividerThickness: 0.0,
                headingRowColor:
                    WidgetStateProperty.all(CustomColors.primaryColor),
                border: TableBorder.all(),
                clipBehavior: Clip.none,
                columns: _createColumns(),
                rows: _createRows(),
              ),
            ),
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

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: CustomText(
          text: 'S.N.',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Bus Number',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Bus Name',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Departure From',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Destination',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Date',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Departure Time',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Arrival Time',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Edit',
          fontWeight: dataColumnFontWeight,
          size: dataColumnFontSize,
          color: dataColumnTextColor,
        ),
      ),
    ];
  }

  List<DataRow> _createRows() {
    return List<DataRow>.generate(
      response.length,
      (index) {
        int i = index;
        return DataRow(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> state) {
              return ++i % 2 == 0
                  ? Colors.greenAccent.withOpacity(0.5)
                  : Colors.white;
            },
          ),
          cells: [
            DataCell(
              CustomText(
                text: '${++i}',
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              CustomText(
                text: response[index]['busNumber'].toString(),
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              CustomText(
                text: response[index]['name'].toString(),
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              CustomText(
                text: response[index]['departureFrom'].toString(),
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              CustomText(
                text: response[index]['destination'].toString(),
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              CustomText(
                text: response[index]['date'].toString(),
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              CustomText(
                text: response[index]['departureTime'].toString(),
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              CustomText(
                text: response[index]['arrivalTime'].toString(),
                fontWeight: dataCellFontWeight,
              ),
            ),
            DataCell(
              PopupMenuButton(
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
                          busNumber: response[index]['busNumber'].toString(),
                          busName: response[index]['name'].toString(),
                          departure:
                              response[index]['departureFrom'].toString(),
                          arrival: response[index]['destination'].toString(),
                          departureTime:
                              response[index]['departureTime'].toString(),
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
        );
      },
    );
  }
}
