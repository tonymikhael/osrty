// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:osrty/constants.dart';
import 'package:osrty/cubit/osrty_cubit.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool isLoaded = false;
  String searcheValue = '';
  List? searchedList;
  @override
  Widget build(BuildContext context) {
    var myCubit = BlocProvider.of<OsrtyCubit>(context);

    return ModalProgressHUD(
      inAsyncCall: isLoaded,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: TextField(
                  onChanged: (value) {
                    searcheValue = value;
                    searchedList = myCubit.searchedList(searcheValue);
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
                child: (searcheValue == "")
                    ? ListView.builder(
                        itemCount: myCubit.usersList.length,
                        itemBuilder: (context, listViewIndex) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                  )
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        myCubit.usersList[listViewIndex].name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Total :  ${myCubit.totalCount(myCubit.usersList[listViewIndex].attendanceList)}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 230,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          10, // Number of avatars in each row
                                      crossAxisSpacing: 8.0, // Adjust as needed
                                      mainAxisSpacing: 8.0, // Adjust as needed
                                    ),
                                    itemCount: 52, // Total number of avata,rs
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              isLoaded = true;
                                            });
                                            if (myCubit.usersList[listViewIndex]
                                                    .attendanceList[index] ==
                                                true) {
                                              var updatedValue =
                                                  myCubit.attendanceHelper(
                                                      index,
                                                      false,
                                                      myCubit
                                                          .usersList[
                                                              listViewIndex]
                                                          .attendanceList);
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      '${myCubit.email}')
                                                  .doc(myCubit
                                                      .usersList[listViewIndex]
                                                      .docId)
                                                  .update({
                                                "attendanceList": updatedValue,
                                              });
                                              if (!mounted) {
                                                return;
                                              }
                                              setState(() {
                                                isLoaded = true;
                                              });
                                            } else {
                                              var updatedValue =
                                                  myCubit.attendanceHelper(
                                                      index,
                                                      true,
                                                      myCubit
                                                          .usersList[
                                                              listViewIndex]
                                                          .attendanceList);
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      '${myCubit.email}')
                                                  .doc(myCubit
                                                      .usersList[listViewIndex]
                                                      .docId)
                                                  .update({
                                                "attendanceList": updatedValue,
                                              });
                                              if (!mounted) {
                                                return;
                                              }
                                              setState(() {
                                                isLoaded = true;
                                              });
                                            }
                                            setState(() {
                                              isLoaded = false;
                                            });
                                          },
                                          child: myCubit
                                                  .usersList[listViewIndex]
                                                  .attendanceList[index]
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      primaryColor, // Avatar background color
                                                  child: Center(
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .white, // Text color
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  child: Text("${index + 1}"),
                                                  radius: 10,
                                                ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : ListView.builder(
                        itemCount: searchedList!.length,
                        itemBuilder: (context, listViewIndex) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                  )
                                ]),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        searchedList![listViewIndex].name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Total :  ${myCubit.totalCount(searchedList![listViewIndex].attendanceList)}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 230,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          10, // Number of avatars in each row
                                      crossAxisSpacing: 8.0, // Adjust as needed
                                      mainAxisSpacing: 8.0, // Adjust as needed
                                    ),
                                    itemCount: 52, // Total number of avata,rs
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () async {
                                            setState(() {
                                              isLoaded = true;
                                            });
                                            if (searchedList![listViewIndex]
                                                    .attendanceList[index] ==
                                                true) {
                                              var updatedValue =
                                                  myCubit.attendanceHelper(
                                                      index,
                                                      false,
                                                      searchedList![
                                                              listViewIndex]
                                                          .attendanceList);
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      '${myCubit.email}')
                                                  .doc(
                                                      searchedList![listViewIndex]
                                                      .docId)
                                                  .update({
                                                "attendanceList": updatedValue,
                                              });
                                              if (!mounted) {
                                                return;
                                              }
                                              setState(() {
                                                isLoaded = true;
                                              });
                                            } else {
                                              var updatedValue =
                                                  myCubit.attendanceHelper(
                                                      index,
                                                      true,
                                                      
                                                          searchedList![
                                                              listViewIndex]
                                                          .attendanceList);
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      '${myCubit.email}')
                                                  .doc(
                                                      searchedList![listViewIndex]
                                                      .docId)
                                                  .update({
                                                "attendanceList": updatedValue,
                                              });
                                              if (!mounted) {
                                                return;
                                              }
                                              setState(() {
                                                isLoaded = true;
                                              });
                                            }
                                            setState(() {
                                              isLoaded = false;
                                            });
                                          },
                                          child: 
                                                  searchedList![listViewIndex]
                                                  .attendanceList[index]
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      primaryColor, // Avatar background color
                                                  child: Center(
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .white, // Text color
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  child: Text("${index + 1}"),
                                                  radius: 10,
                                                ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
              ),
            ],
          )),
    );
  }
}
