// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:osrty/models/user_class.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searcheValue = '';
  @override
  Widget build(BuildContext context) {
    var myCubit = BlocProvider.of<OsrtyCubit>(context);
    // Stream<QuerySnapshot> users;

    // users = FirebaseFirestore.instance
    //     .collection('${myCubit.email}')
    //     .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: (searcheValue != "" && searcheValue != null)
          ? FirebaseFirestore.instance
              .collection("${myCubit.email}")
              .where("name", isGreaterThanOrEqualTo: searcheValue)
              .snapshots()
          : FirebaseFirestore.instance
              .collection("${myCubit.email}")
              .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        myCubit.usersList = [];
        if (snapshot.hasData) {
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            String id = snapshot.data!.docs[i].id;

            myCubit.usersList.add(UserModel(
              docId: id,
              attendanceList: snapshot.data!.docs[i]['attendanceList'],
              isIftekad: snapshot.data!.docs[i]['isIftekad'],
              name: snapshot.data!.docs[i]['name'],
              phone1: snapshot.data!.docs[i]['phone1'],
              phone2: snapshot.data!.docs[i]['phone2'],
              address: snapshot.data!.docs[i]['address'],
              bornDate: snapshot.data!.docs[i]['bornDate'] ?? "",
            ));
          }
        }
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return snapshot.data!.docs.isNotEmpty
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 16),
                    child: TextField(
                      onSubmitted: (value) {
                        searcheValue = value;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: "search",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: Icon(Icons.search)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ListView.builder(
                        itemCount: myCubit.usersList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                onLongPress: () {
                                  PanaraConfirmDialog.show(
                                    context,

                                    title: "Delete",
                                    message: "do you want to delete this user?",
                                    confirmButtonText: "Confirm",
                                    cancelButtonText: "Cancel",

                                    onTapCancel: () {
                                      Navigator.pop(context);
                                    },
                                    onTapConfirm: () async {
                                      String id = snapshot.data!.docs[index].id;
                                      await FirebaseFirestore.instance
                                          .collection('${myCubit.email}')
                                          .doc(id)
                                          .delete();
                                      // Navigator.pop(context);
                                    },
                                    panaraDialogType: PanaraDialogType.error,
                                    barrierDismissible:
                                        true, // optional parameter (default is true)
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 2)
                                      ],
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            overflow: TextOverflow.clip,
                                            myCubit.usersList[index].name,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(
                                            flex: 2,
                                          ),
                                          Text(
                                            myCubit.usersList[index].bornDate,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              myCubit.usersList[index].phone1,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              myCubit.usersList[index].phone2,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            myCubit.usersList[index].isIftekad
                                                ? Column(
                                                    children: [
                                                      Text(
                                                        "الافتقاد",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                FontWeight
                                                                    .bold),
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
                                        myCubit.usersList[index].address,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: -15,
                                child: CircleAvatar(
                                  radius: 20,
                                  child: IconButton(
                                      iconSize: 25,
                                      onPressed: () async {
                                        String id =
                                            snapshot.data!.docs[index].id;
                                        Box<Map<dynamic, dynamic>> box =
                                            await Hive.box<
                                                    Map<dynamic, dynamic>>(
                                                'users2');
                                        box.add({
                                          "bornDate":
                                              myCubit.usersList[index].bornDate,
                                          "name": myCubit.usersList[index].name,
                                          "phone1":
                                              myCubit.usersList[index].phone1,
                                          "phone2":
                                              myCubit.usersList[index].phone2,
                                          "address":
                                              myCubit.usersList[index].address,
                                          'docId': id,
                                          'isIftekad': myCubit
                                              .usersList[index].isIftekad,
                                        });
                                        // print(box.getAt(index)!['bornDate']);
                                      },
                                      icon:
                                          Icon(Icons.favorite_border_outlined)),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 16),
                      child: TextField(
                        onSubmitted: (value) {
                          searcheValue = value;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          hintText: "search",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: Icon(Icons.search)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "No users yet",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
