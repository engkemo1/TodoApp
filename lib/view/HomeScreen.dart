
import 'dart:math';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/services/themes.dart';
import 'package:todoapp/view/Notificarion.dart';
import 'package:todoapp/widget/appbar.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../services/notification_services.dart';
import '../services/theme_services.dart';
import '../size_config.dart';
import '../widget/task_tile.dart';
import 'AddTask.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController _taskController = Get.put(TaskController());
  NotifyHelper notifyHelper = NotifyHelper();
  DateTime _selectedate = DateTime.now();
  double value = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController.getTask();
    SizeConfig.orientation = Orientation.portrait;
    SizeConfig.screenHeight = 100;
    SizeConfig.screenWidth = 100;
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIosPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        leadingWidget: IconButton(onPressed: (){
          notifyHelper.cancelAllNotification();
          _taskController.deleteAllTasks();
        }, icon: Icon(Icons.delete,color:const Color(0xff3ac21b),)),
      ),
      body:SafeArea(child: Stack(
        children: [
          //Background of Drawer
          Container(
            decoration: BoxDecoration(
             color: const Color(0xff00334a)
            ),
          ),
          //Navigation Menu
          SafeArea(
            child: Container(
              width: 200.0,
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage(
                              "images/person.jpeg"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Welcome",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onTap: () {
                            Get.to(() => HomeScreen(),
                                transition: Transition.downToUp,
                                duration: Duration(milliseconds: 500));
                          },
                        ),

                        ListTile(
                          leading: Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Add Task",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onTap: () {
                            Get.to(() => AddTaskScreen(),
                                transition: Transition.downToUp,
                                duration: Duration(milliseconds: 500));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Notification",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          onTap: () {

                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.brightness_4,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Theme",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          onTap: () {
                            ThemeServices().switchTheme();
                            NotifyHelper().displayNotification(title: "hello", body: "body");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Screen
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return (
                  //Transform Widget
                  Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..setEntry(0, 3, 200 * val)
                        ..rotateY((pi / 6) * val),
                      child:Scaffold(

                          body: SafeArea(child:Container(
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${DateFormat.yMMMMd().format(DateTime.now())}'
                                          ,
                                          style: Themes().homeScreenSubHeadingTextStyle,

                                        ),
                                        Text(
                                          'Today',
                                          style: Themes().homeScreenHeadingTextStyle,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                _dateBar(),
                                _tasks()      ],
                            ),
                          )),

                          ))
                      );
            },
          ),
          GestureDetector(
            onHorizontalDragUpdate: (e) {
              if (e.delta.dx > 0) {
                setState(() {
                  value = 1;
                });
              } else {
                setState(() {
                  value = 0;
                });
              }
            },

          ),
          // Gesture Detector to Open the Drawer.

        ],
      ),
      ),

    );
  }

  Widget _dateBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        onDateChange: (newDate) {
          setState(() {
            _selectedate = newDate;
          });
        },
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: Colors.green,
        dayTextStyle:
        TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        dateTextStyle: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        monthTextStyle:
        TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _tasks() {
    return Expanded(child: Obx(() {
      if (_taskController.taskList.isEmpty) {
        return _noTasksMessage();
      } else {
        return AnimationLimiter(
          child: ListView.builder(
              scrollDirection:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              itemCount: _taskController.taskList.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = _taskController.taskList[index];
                var date = DateFormat.jm().parse(task.startTime!);
                var myTime = DateFormat('HH:mm').format(date);
                handlingReminder(task.remind!, myTime, task);
                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedate) ||
                    (task.repeat == 'Weekly' && _selectedate.difference(DateFormat.yMd().parse(task.date!)).inDays % 7 == 0)||
                    (task.repeat == 'Monthly' && DateFormat.yMd().parse(task.date!).day == _selectedate.day) ){
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 500 + index * 20),
                    child: SlideAnimation(
                      horizontalOffset: 400.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => displayBottomSheet(context, task),
                          child: TaskTile(task: task),
                        ),
                      ),
                    ),
                  );
                } else
                  return SizedBox(
                    height: 0,
                  );
              }),
        );
      }
    }));
  }

  displayBottomSheet(context, Task task) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return _bottomSheet(task);
        });
  }

  Widget _bottomSheet(Task task) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.2
          : MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          task.isCompleted == 0
              ? ElevatedButton(
              onPressed: () {
                notifyHelper.cancelNotification(task.id!);
                _taskController.markAsCompleted(task.id);
                Get.back();
              },
              child: Text("Complete Task"))
              : SizedBox(
            height: 0,
          ),
          ElevatedButton(
              onPressed: () {
                _taskController.deleteTask(task.id);
                notifyHelper.cancelNotification(task.id!);
                Get.back();
              },
              child: Text("Delete Task")),
          ElevatedButton(onPressed: () => Get.back(), child: Text("Cancel"))
        ],
      ),
    );
  }

  Widget _noTasksMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaQuery.of(context).orientation == Orientation.portrait
                ? const SizedBox(
              height: 0,
            )
                : const SizedBox(
              height: 50,
            ),
            Image.asset(
              'images/list.png',
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            Text("There Is No Tasks"),
          ],
        ),
      ),
    );
  }

  handlingReminder(int reminder, var myTime, Task task) {
    var minutes = int.parse(myTime.toString().split(':')[1]);
    var hours = int.parse(myTime.toString().split(':')[0]);
    if (reminder == 5) {
      notifyHelper.scheduledNotification(minutes < 5 ? hours - 1 : hours,
          minutes < 5 ? minutes + 55 : minutes - 5, task);
    } else if (reminder == 10) {
      notifyHelper.scheduledNotification(minutes < 10 ? hours - 1 : hours,
          minutes < 10 ? minutes + 50 : minutes - 10, task);
    } else if (reminder == 15) {
      notifyHelper.scheduledNotification(minutes < 15 ? hours - 1 : hours,
          minutes < 15 ? minutes + 45 : minutes - 15, task);
    } else
      notifyHelper.scheduledNotification(minutes < 20 ? hours - 1 : hours,
          minutes < 20 ? minutes + 40 : minutes - 20, task);
  }

}
