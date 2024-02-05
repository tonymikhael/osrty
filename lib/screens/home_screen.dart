// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:osrty/screens/add.dart';
import 'package:osrty/screens/attendance.dart';
import 'package:osrty/screens/favourite.dart';
import 'package:osrty/screens/home.dart';
import 'package:osrty/screens/setting_screen.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool connected = false;
  final List<Widget> _pages = [
    const Home(),
    const Add(),
    Favourite(),
    const Attendance(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    myNotificationRequest();
    super.initState();
  }

  myNotificationRequest() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    var myCubit = BlocProvider.of<OsrtyCubit>(context);
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return snapshot.data == ConnectivityResult.none
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/no_intenet.png'),
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Text(
                        "no internet connection",
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          PanaraConfirmDialog.show(
                            context,

                            title: "Delete",
                            message: "هل تريد مسح القائمة كلها؟",
                            confirmButtonText: "Confirm",
                            cancelButtonText: "Cancel",

                            onTapCancel: () {
                              Navigator.pop(context);
                            },
                            onTapConfirm: () async {
                              // var box =
                              //     Hive.box<Map<dynamic, dynamic>>("users2");
                              // box.clear();
                              Navigator.pop(context);
                              var collection = FirebaseFirestore.instance
                                  .collection('${myCubit.email}');
                              var snapshots = await collection.get();
                              for (var doc in snapshots.docs) {
                                await doc.reference.delete();
                              }
                            },
                            panaraDialogType: PanaraDialogType.warning,
                            barrierDismissible:
                                true, // optional parameter (default is true)
                          );
                        },
                        icon: Icon(Icons.delete)),
                  ],
                  title: Text('Osrty'),
                ),
                body: _pages[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt),
                      label: 'List',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add),
                      label: 'Add',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favourite',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.event),
                      label: 'Attendance',
                    ),
                  ],
                ),
              );
      },
    );
  }
}
