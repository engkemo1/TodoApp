

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todoapp/models/task.dart';

import '../services/notification_services.dart';
import '../services/theme_services.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key, this.leadingWidget}) : super(key: key);
  final Widget? leadingWidget;
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      leading: leadingWidget,
      actions: [
        IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
            NotifyHelper().displayNotification(title: "hello", body: "body");

          },
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
          ),
          color: Get.isDarkMode ? Colors.white : Colors.black,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}