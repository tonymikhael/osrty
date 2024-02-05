// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';
import 'package:osrty/components/login_button.dart';
import 'package:osrty/components/text_form_field.dart';
import 'package:osrty/cubit/osrty_cubit.dart';
import 'package:osrty/models/user_class.dart';
import 'package:osrty/screens/home.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  String name = "";
  String phone1 = "";
  String phone2 = "";
  String address = "";
  bool addedFlag = false;
  String formattedDate = "";
  List<bool> attendanceList = List.generate(52, (index) => false);

  var datePicked;
  var _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _phone1Controller = TextEditingController();
  var _phone2Controller = TextEditingController();
  var _addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var myCubit = BlocProvider.of<OsrtyCubit>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomizedTextFormField(
                      maxLength: 30,
                      controller: _nameController,
                      hintText: "name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "required";
                        }
                      },
                      onChanged: (value) {
                        name = value;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomizedTextFormField(
                      maxLength: 11,
                      controller: _phone1Controller,
                      keyboardType: TextInputType.phone,
                      hintText: "phone1",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "required";
                        } else if (value.length >= 0 && value.length < 11) {
                          return "phone number is wrong";
                        }
                      },
                      onChanged: (value) {
                        phone1 = value;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomizedTextFormField(
                      maxLength: 11,
                      controller: _phone2Controller,
                      keyboardType: TextInputType.phone,
                      hintText: "phone2",
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return "required";
                        // } else if (value.length >= 0 && value.length < 11) {
                        //   return "phone number is wrong";
                        // }
                      },
                      onChanged: (value) {
                        phone2 = value;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomizedTextFormField(
                      controller: _addressController,
                      hintText: "address",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "required";
                        }
                      },
                      onChanged: (value) {
                        address = value;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomizedButton(
                    hintText: "select born date",
                    onPressed: () async {
                      datePicked = await DatePicker.showSimpleDatePicker(
                        context,
                        // initialDate: DateTime(2020),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2090),
                        dateFormat: "dd-MMMM-yyyy",
                        locale: DateTimePickerLocale.en_us,
                        looping: true,
                      );
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        print('$datePicked');
                      });

                      if (datePicked != null) {
                        print(
                            datePicked); //pickedDate output format => 2021-03-10 00:00:00.000
                        formattedDate =
                            DateFormat('yyyy-MM-dd').format(datePicked);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                      } else {
                        print("Date is not selected");
                      }
                    },
                    width: 180,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  datePicked != null
                      ? Text("$formattedDate")
                      : SizedBox(
                          height: 5,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            CustomizedButton(
              hintText: "Add",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  CollectionReference user = FirebaseFirestore.instance
                      .collection('${myCubit.email}');

                  // Call the user's CollectionReference to add a new user
                  await user.add({
                    'name': name,
                    'phone1': phone1,
                    'phone2': phone2,
                    'address': address,
                    'bornDate': formattedDate,
                    'attendanceList': attendanceList,
                    'isIftekad': false,
                  }).then(
                    (value) {
                      print("added");
                      addedFlag = true;
                    },
                  ).catchError((error) => print("Failed to add user: $error"));
                }

                Future.delayed(
                  const Duration(milliseconds: 2000),
                  () {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      addedFlag = false;
                    });
                  },
                );
                if (!mounted) {
                  return;
                }
                setState(() {
                  datePicked = "";
                  _nameController.clear();
                  _phone1Controller.clear();
                  _phone2Controller.clear();
                  _addressController.clear();
                });
              },
            ),
            Visibility(
              visible: addedFlag,
              child: Text(
                "Added successfuly",
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
