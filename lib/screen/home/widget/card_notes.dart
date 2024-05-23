// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:php_flutter/components/crud.dart';
import 'package:php_flutter/constant/links_api.dart';
import 'package:php_flutter/main.dart';
import 'package:php_flutter/screen/home/home_page.dart';

class CardNotes extends StatelessWidget {
  CardNotes({
    super.key,
    required this.onTap,
    required this.notesTitle,
    required this.notesContent,
    required this.noteId,
    required this.imageRout,
  });
  final String notesTitle;
  final String notesContent;
  final Function onTap;
  final int noteId;
  final String imageRout;
  final Crud _crud = Crud();
  final userId = sharedPref.getString("id").toString();
  deleteNote() async {
    var response = await _crud.postRequest(
        linkDeleteNotes, {"noteId": noteId.toString(), "imageName": imageRout});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap(),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 10,
        //shadowColor: Colors.white,
        surfaceTintColor: Colors.lightBlueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                '$linkImageRoute/$imageRout',
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 4,
              child: ListTile(
                title: Text(notesTitle),
                subtitle: Text(notesContent),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  deleteNote();
                  await Future.delayed(const Duration(seconds: 1));
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Container(
                  color: Colors.red,
                  height: double.infinity,
                  child: const Center(
                      child: Icon(
                    Icons.delete_forever_sharp,
                    color: Colors.white,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
