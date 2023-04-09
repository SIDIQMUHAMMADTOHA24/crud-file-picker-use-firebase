import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_piker_storage_firebase/pages/update_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_data.dart';

class DasboardPages extends StatefulWidget {
  const DasboardPages({super.key});

  @override
  State<DasboardPages> createState() => _DasboardPagesState();
}

class _DasboardPagesState extends State<DasboardPages> {
  final _ref = FirebaseFirestore.instance.collection('person');

  //!logout
  doLogOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //! dodelete
  _delete(String userid) async {
    await _ref.doc(userid).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('User successfully deleted ')));
  }

  //! text controller
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () => doLogOut(), icon: Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder(
          stream: _ref.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Loading'));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        leading: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdatePages(
                                      documentSnapshot: data,
                                      imageUrl: data['imageUrl'],
                                      name: data['nama'],
                                    ),
                                  ));
                            },
                            icon: Icon(Icons.edit)),
                        title: Text(data['nama']),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                    data['imageUrl'],
                                    fit: BoxFit.cover,
                                  )),
                              Spacer(),
                              //! delete
                              IconButton(
                                  onPressed: () => _delete(data.id),
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        )),
                  );
                },
              );
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDataPages(),
              )),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
