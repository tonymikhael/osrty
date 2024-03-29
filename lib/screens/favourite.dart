// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:osrty/constants.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class Favourite extends StatefulWidget {
  Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  bool isIfekad = false;
  var box = Hive.box<Map>("users2");

  @override
  Widget build(BuildContext context) {
    var myCubit = BlocProvider.of<OsrtyCubit>(context);
    return box.isNotEmpty
        ? ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
            valueListenable:
                Hive.box<Map<dynamic, dynamic>>('users2').listenable(),
            builder: ((context, Box<Map<dynamic, dynamic>> box, child) {
              return Padding(
                padding: EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            PanaraConfirmDialog.show(
                              context,
                              title: "Delete",
                              message: "اعادة ضبط الافتقاد ؟",
                              confirmButtonText: "Confirm",
                              cancelButtonText: "Cancel",
                              onTapCancel: () {
                                Navigator.pop(context);
                              },
                              onTapConfirm: () async {
                                var instance = await FirebaseFirestore.instance;
                                for (int index = 0;
                                    index < box.length;
                                    index++) {
                                  instance
                                      .collection('${myCubit.email}')
                                      .doc(box.getAt(index)!['docId'])
                                      .update({
                                    "isIftekad": false,
                                  });
                                  box.putAt(index, {
                                    "isIftekad": false,
                                    "docId": box.getAt(index)!['docId'],
                                    "name": box.getAt(index)!['name'],
                                    "phone1": box.getAt(index)!['phone1'],
                                    "phone2": box.getAt(index)!['phone2'],
                                    "address": box.getAt(index)!['address'],
                                    "bornDate": box.getAt(index)!['bornDate'],
                                  });
                                }
                                Navigator.pop(context);
                              },
                              panaraDialogType: PanaraDialogType.error,
                              barrierDismissible:
                                  true, // optional parameter (default is true)
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.list_alt),
                                Text(
                                  "اعاده ضبط الافتقاد ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            PanaraConfirmDialog.show(
                              context,
                              title: "Delete",
                              message: "مسح المفضلة كلها ؟",
                              confirmButtonText: "Confirm",
                              cancelButtonText: "Cancel",
                              onTapCancel: () {
                                Navigator.pop(context);
                              },
                              onTapConfirm: () {
                                setState(() {});
                                var box = Hive.box<Map>('users2');
                                box.clear();
                                Navigator.pop(context);
                              },
                              panaraDialogType: PanaraDialogType.error,
                              barrierDismissible:
                                  true, // optional parameter (default is true)
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.delete_forever_sharp),
                                Text(
                                  "مسح المفضلة",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (vlaue) async {
                                      if (box.getAt(index)!['isIftekad'] ==
                                          false) {
                                        await FirebaseFirestore.instance
                                            .collection('${myCubit.email}')
                                            .doc(box.getAt(index)!['docId'])
                                            .update({
                                          "isIftekad": true,
                                        });
                                        box.putAt(index, {
                                          "isIftekad": true,
                                          "docId": box.getAt(index)!['docId'],
                                          "name": box.getAt(index)!['name'],
                                          "phone1": box.getAt(index)!['phone1'],
                                          "phone2": box.getAt(index)!['phone2'],
                                          "address":
                                              box.getAt(index)!['address'],
                                          "bornDate":
                                              box.getAt(index)!['bornDate'],
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection('${myCubit.email}')
                                            .doc(box.getAt(index)!['docId'])
                                            .update({
                                          "isIftekad": false,
                                        });
                                        box.putAt(index, {
                                          "isIftekad": false,
                                          "docId": box.getAt(index)!['docId'],
                                          "name": box.getAt(index)!['name'],
                                          "phone1": box.getAt(index)!['phone1'],
                                          "phone2": box.getAt(index)!['phone2'],
                                          "address":
                                              box.getAt(index)!['address'],
                                          "bornDate":
                                              box.getAt(index)!['bornDate'],
                                        });
                                      }
                                    },
                                    flex: 2,
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.done,
                                    label: 'تم الافتقاد',
                                  ),
                                  SlidableAction(
                                    onPressed: (value) {
                                      setState(() {});
                                      box.deleteAt(index);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'حذف',
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    boxShadow: [BoxShadow(blurRadius: 2)],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.deepPurpleAccent,
                                          child: Text(
                                            "${index + 1}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          box.getAt(index)!['name'].toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(
                                          flex: 2,
                                        ),
                                        Text(
                                          "${box.getAt(index)!['bornDate']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path:
                                                    box.getAt(index)!['phone1'],
                                              );
                                              await launchUrl(launchUri);
                                            },
                                            child: Text(
                                              box
                                                  .getAt(index)!['phone1']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.greenAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path:
                                                    box.getAt(index)!['phone2'],
                                              );
                                              await launchUrl(launchUri);
                                            },
                                            child: Text(
                                              box
                                                  .getAt(index)!['phone2']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.greenAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Spacer(),
                                          box.getAt(index)!["isIftekad"]
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      "الافتقاد",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.done_sharp,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Text(
                                                      "الافتقاد",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.warning,
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      box.getAt(index)!['address'].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          )
        : Center(
            child: Text(
              "No favourite yet",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          );
  }
}
