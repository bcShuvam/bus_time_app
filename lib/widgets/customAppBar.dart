import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:json/pages/showBusTimeTable.dart';
import 'package:json/pages/showBusTime.dart';
import 'package:json/widgets/customText.dart';

class AppBarWidget extends StatelessWidget {
  AppBarWidget(
      {required this.tabName,
      this.color,
      this.fontWeight,
      this.size,
      this.isShowCard = true,
      this.showTrailingIcons = false,
      this.showPopupMenu = false,
      super.key});

  final String tabName;
  final Color? color;
  final FontWeight? fontWeight;
  final double? size;
  final bool isShowCard;
  final bool showTrailingIcons;
  final bool showPopupMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: CustomText(
          text: tabName,
          fontWeight: fontWeight ?? FontWeight.bold,
          size: size ?? 28.0,
          color: color ?? Colors.black,
        ),
        leading: InkWell(
          onTap: () {
            Get.off(const ShowBustime());
          },
          child: const Image(
            image: AssetImage('assets/icons/logo.png'),
          ),
        ),
        actions: showTrailingIcons
            ? [
                showPopupMenu
                    ? PopupMenuButton(
                        icon: const FaIcon(FontAwesomeIcons.bars),
                        // constraints: BoxConstraints.loose(Size(8.0, 8.0)),
                        position: PopupMenuPosition.under,
                        // iconSize: 24.0,
                        // iconColor: Colors.green,
                        color: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: CustomText(text: 'Change view'),
                              onTap: () {
                                isShowCard
                                    ? Get.off(const ShowBustime())
                                    : Get.off(const DataTablePage());
                                debugPrint('tapped $isShowCard');
                              },
                            ),
                            // PopupMenuItem(
                            //   onTap: () {
                            //     debugPrint('tapped delete');
                            //   },
                            //   child: CustomText(text: 'Delete'),
                            // ),
                          ];
                        },
                      )
                    : Container(),
              ]
            : null,
      ),
    );
  }
}
