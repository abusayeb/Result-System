// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Text(
                  "Department",
                  style: GoogleFonts.bebasNeue(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),

              //TextformField for Department

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      cursorColor: Colors.blueAccent,
                      decoration: textInputDecoration.copyWith(
                          prefixIcon:
                              const Icon(Icons.text_fields, color: Colors.blue),
                          hintText: "",
                          hintStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                          )),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (val) {},
                    ),
                  ),
                ),
              ),

              space(20),

              //Drop box semester

              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Container(
                  height: 60,
                  width: 300,
                  child: FormHelper.dropDownWidget(
                    context,
                    "Select here",
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
                    borderColor: Colors.blueAccent.withOpacity(.5),
                    enabledBorderWidth: 3,
                    borderRadius: 10,
                    optionValue: "id",
                    optionLabel: "label",
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                    height: 50,
                    width: 280,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(.5),
                    ),
                    child: FlatButton(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      onPressed: () {
                        convert();
                      },
                    )),
              ),
            ],
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
}
