import 'package:flutter/material.dart';
import 'package:php_flutter/auth/log_in.dart';
import 'package:php_flutter/components/crud.dart';
import 'package:php_flutter/constant/links_api.dart';
import 'package:php_flutter/main.dart';
import 'package:php_flutter/screen/addnotepage/add_note_page.dart';
import 'package:php_flutter/screen/home/widget/card_notes.dart';
import 'package:php_flutter/screen/update/update_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Crud _crud = Crud();
  late Future<dynamic> _notesFuture;
  final userId = sharedPref.getString("id").toString();

  @override
  void initState() {
    super.initState();
    _notesFuture = getNotes();
  }

  Future<dynamic> getNotes() async {
    var response = await _crud.postRequest(linkViewNotes, {"noteUser": userId});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    var mh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (value) => const LoginPage()));
              sharedPref.clear();
            },
            elevation: 12,
            child: const Icon(Icons.output_rounded),
          )
        ],
      ),
      body: SizedBox(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _notesFuture = getNotes();
            });
          },
          child: FutureBuilder(
            future: _notesFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data['status'] == false) {
                return const Center(
                  child: Text('No data available'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data['data'].length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (value) => UpdateNotePage(
                            noteId: snapshot.data['data'][index]['noteId']
                                .toString(),
                            noteTitle: snapshot.data['data'][index]
                                ['noteTitle'],
                            noteContent: snapshot.data['data'][index]
                                ['noteContent'],
                            noteImage: snapshot.data['data'][index]
                                ['noteImage']!,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: mh / 7,
                      child: CardNotes(
                        notesTitle: snapshot.data['data'][index]['noteTitle'],
                        notesContent: snapshot.data['data'][index]
                            ['noteContent'],
                        onTap: () {},
                        noteId: snapshot.data['data'][index]['noteId'],
                        imageRout: snapshot.data['data'][index]['noteImage'],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (value) => const AddNotePage()));
        },
        tooltip: 'Add a new note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
