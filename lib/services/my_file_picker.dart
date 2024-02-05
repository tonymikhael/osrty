import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class pickFileService {
  late PlatformFile? file;
  List<bool> checkboxValues = List.generate(52, (index) => false);

  selectFile(String collectionName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'csv',
      ],
    );

    if (result != null) {
      file = result.files.first;

      print('File picked: ${file!.name}');
      print('File path: ${file!.path}');
      print('File size: ${file!.size}');

      final input = File("${file!.path}").openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();
      for (int i = 0; i < fields.length; i++) {
        String name = fields[i][1].toString();
        String phone1 = fields[i][2].toString();
        String phone2 = fields[i][3].toString();
        String bornDate = fields[i][4].toString();
        String address = fields[i][5].toString();
        CollectionReference user =
            FirebaseFirestore.instance.collection(collectionName);

        // Call the user's CollectionReference to add a new user
        await user.add({
          'name': name,
          'phone1': phone1,
          'phone2': phone2,
          'address': address,
          'bornDate': bornDate,
          'attendanceList': checkboxValues,
          'isIftekad': false,
        });
      }
    } else {
      print("not loaded ");
    }
  }
}
