// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gjobs/Page/firebase_push.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../widgets/widgets.dart';

class file_pick extends StatefulWidget {
  const file_pick({Key? key}) : super(key: key);

  @override
  State<file_pick> createState() => _file_pickState();
}

class _file_pickState extends State<file_pick> {
  var name = "Select a excel file";
  final formkey = GlobalKey<FormState>();
  bool dec = false;

  void Dec() {
    setState(() {
      name = name;
    });
  }

  //semester drop down box
  List<dynamic> semester = [];

  String? semesterId = "";
  String? selected_sem = "";
  String? session = "";

  @override
  void initState() {
    super.initState();
    this.semester.add({"id": 1, "label": "1st"});
    this.semester.add({"id": 2, "label": "2nd"});
    this.semester.add({"id": 3, "label": "3rd"});
    this.semester.add({"id": 4, "label": "4th"});
    this.semester.add({"id": 5, "label": "5th"});
    this.semester.add({"id": 6, "label": "6th"});
    this.semester.add({"id": 7, "label": "7th"});
    this.semester.add({"id": 8, "label": "8th"});
  }

  List<Map<String, dynamic>> json = <Map<String, dynamic>>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlueAccent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Upload Result",
                      style: GoogleFonts.bebasNeue(
                          color: Colors.white, fontSize: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          space(20),

                          //TextformField for Department

                          Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: TextFormField(
                                cursorColor: Colors.blueAccent,
                                textAlign: TextAlign.center,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "2018-19",
                                    label: Text(
                                      "Session",
                                      style: GoogleFonts.bebasNeue(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    alignLabelWithHint: true,
                                    hintStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    )),
                                onChanged: (value) {
                                  setState(() {
                                    session = value;
                                  });
                                },
                                validator: (val) {
                                  if (val == '2016-17' ||
                                      val == '2017-18' ||
                                      val == '2018-19' ||
                                      val == '2019-20' ||
                                      val == '2020-21' ||
                                      val == '2021-22' ||
                                      val == '2022-23') {
                                    return null;
                                  } else {
                                    return "Please insert the correct value on given format";
                                  }
                                },
                              ),
                            ),
                          ),

                          space(10),

                          //Drop box semester

                          Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(10)),
                            child: FormHelper.dropDownWidget(
                              context,
                              "Semester",
                              this.semesterId,
                              this.semester,
                              (onChangedVal) {
                                selected_sem = onChangedVal;
                              },
                              (onValidateVal) {
                                if (onValidateVal == null) {
                                  return 'Please Select one option';
                                }

                                return null;
                              },
                              paddingLeft: 100,
                              paddingRight: 0,
                              focusedBorderWidth: 0,
                              validationColor: Colors.transparent,
                              borderFocusColor: Colors.transparent,
                              borderColor: Colors.transparent,
                              enabledBorderWidth: 0,
                              borderRadius: 5,
                              textColor: Colors.blue,
                              optionValue: "id",
                              optionLabel: "label",
                            ),
                          ),
                          space(10),

                          //Excel file select button
                          Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: FlatButton(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                onPressed: () {
                                  convert();
                                },
                              )),
                          space(15),

                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                validate();
                              },
                              style: ButtonStyle(),
                              child: Text(
                                "upload",
                                style: GoogleFonts.bebasNeue(fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  convert() async {
    FilePickerResult? file = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);
    if (file != null && file.files.isNotEmpty) {
      var bytes = File(file.files.first.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      int i = 0;
      List<dynamic> keys = <dynamic>[];
      if (file != null) {
        name = file.files.single.name;
      }

      List<String> tag;

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          try {
            if (i == 0) {
              keys = row;
              i++;
            } else {
              Map<String, dynamic> temp = Map<String, dynamic>();
              int j = 0;
              String tk = '';
              for (var key in keys) {
                tk = key.value;
                temp[tk] = (row[j].runtimeType == String)
                    ? "\u201C" + row[j]?.value + "\u201D"
                    : row[j]?.value;
                j++;
              }
              json.add(temp);
            }
          } catch (e) {}
        }
      }
      Dec();
    }
  }

  validate() async {
    if (formkey.currentState!.validate()) {
      print(session);
      String sem = semester[int.parse(selected_sem!)]['label'];
      print(semester[int.parse(selected_sem!)]['label']);
      print(json[0]);
      List<String> courses = [];
      json.forEach((element) {
        courses = element.keys.toList();
      });
      final format = {json[0]};
      print(format);
      print(json[0].length);
      final firestore = FirebaseFirestore.instance;
      // firestore.collection("cse/$session/$sem/$json[0]['Roll']").add({});
    }
  }
}
