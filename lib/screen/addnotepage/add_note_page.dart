// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:php_flutter/components/crud.dart';
import 'package:php_flutter/constant/links_api.dart';
import 'package:php_flutter/main.dart';
import 'package:php_flutter/screen/home/home_page.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteContent = TextEditingController();
  final Crud _crud = Crud();
  File? myFile;
  addNote() async {
    if (myFile == null) {
      log('pleas add image');
    }
    var response = await _crud.postRequestWithFile(
        linkAddNotes,
        {
          "noteTitle": noteTitle.text.toString(),
          "noteContent": noteContent.text.toString(),
          "noteUser": sharedPref.getString("id").toString(),
        },
        myFile!);

    if (response != null && response is Map<String, dynamic>) {
      if (response.containsKey("status") && response["status"] == true) {
        // Registration successful
      } else {
        // Registration failed or status not found in response
        log('add note failed');
      }
    } else {
      // Invalid or null response
      log('Invalid response from server');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add your note'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'note title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: noteTitle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'note content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: noteContent,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Colors.blue[700],
                  ),
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () async {
                      XFile? xFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {
                        myFile = File(xFile!.path);
                      });
                    },
                    child: const Text("choose image from galary"),
                  )),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: Colors.blue[700],
                ),
                alignment: Alignment.topCenter,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () async {
                    XFile? xFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    setState(() {
                      myFile = File(xFile!.path);
                    });
                  },
                  child: const Text("choose image from camera"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  child: myFile == null
                      ? Image.network(
                          noteImage,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: FileImage(myFile!),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            addNote();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          }
        },
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
