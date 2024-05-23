import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:php_flutter/components/crud.dart';
import 'package:php_flutter/constant/links_api.dart';
import 'package:php_flutter/screen/home/home_page.dart';

class UpdateNotePage extends StatefulWidget {
  const UpdateNotePage({
    Key? key,
    required this.noteId,
    required this.noteTitle,
    required this.noteContent,
    required this.noteImage,
  }) : super(key: key);

  final String noteId;
  final String noteTitle;
  final String noteContent;
  final String noteImage;

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  late TextEditingController _noteTitleController;
  late TextEditingController _noteContentController;
  final Crud _crud = Crud();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _noteTitleController = TextEditingController(text: widget.noteTitle);
    _noteContentController = TextEditingController(text: widget.noteContent);
  }

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteContentController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    try {
      var response;

      if (_selectedImage == null) {
        // If no new image is selected, update note without changing the image
        response = await _crud.postRequest(linkUpdateNotes, {
          "noteTitle": _noteTitleController.text,
          "noteContent": _noteContentController.text,
          "noteId": widget.noteId,
          "noteImage": widget.noteImage, // Keep the original image
        });
      } else {
        // If a new image is selected, update note with the new image
        response = await _crud.postRequestWithFile(
          linkUpdateNotes,
          {
            "noteTitle": _noteTitleController.text,
            "noteContent": _noteContentController.text,
            "noteId": widget.noteId,
            "noteImage": widget.noteImage, // Keep the original image
          },
          _selectedImage!,
        );
      }

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey("status") && response["status"] == true) {
          // Note updated successfully
          log('Note updated successfully');
          return;
        }
      }

      log('Update note failed');
    } catch (e) {
      log('Error updating note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Note'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Note Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title for the note';
                }
                return null;
              },
              controller: _noteTitleController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Note Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter content for the note';
                }
                return null;
              },
              controller: _noteContentController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                setState(() {
                  _selectedImage = image != null ? File(image.path) : null;
                });
              },
              child: const Text("Choose Image from Gallery"),
            ),
            const SizedBox(height: 16),
            if (_selectedImage != null || widget.noteImage.isNotEmpty)
              Expanded(
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        '$linkImageRoute/${widget.noteImage}',
                        fit: BoxFit.cover,
                      ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_noteTitleController.text.isNotEmpty &&
              _noteContentController.text.isNotEmpty) {
            _updateNote();
            await Future.delayed(const Duration(seconds: 1));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill all fields'),
              ),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
