import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddDataPages extends StatefulWidget {
  const AddDataPages({super.key});

  @override
  State<AddDataPages> createState() => _AddDataPagesState();
}

class _AddDataPagesState extends State<AddDataPages> {
  final _nameController = TextEditingController();

  final _ref = FirebaseFirestore.instance.collection('person');
  PlatformFile? pickedFiles;
  UploadTask? uploadTask;
  String imageUrl = '';

  //! get file
  getFiles() async {
    final resault = await FilePicker.platform.pickFiles();
    if (resault != null) {
      pickedFiles = resault.files.first;
      setState(() {});
    }
    uploadFiles();
  }

  //!upload files
  uploadFiles() async {
    final path = 'files/${pickedFiles!.name}';
    final file = File(pickedFiles!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final snapshot = await ref.putFile(file).whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    imageUrl = urlDownload;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(
              height: 100,
              width: 100,
              child: pickedFiles != null
                  ? Image.file(File(pickedFiles!.path!))
                  : Container(),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'nama'),
            ),
            ElevatedButton(onPressed: () => getFiles(), child: Text('File')),
            ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isNotEmpty && imageUrl.isNotEmpty) {
                    await _ref.add(
                        {'nama': _nameController.text, 'imageUrl': imageUrl});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text(
                            '${_nameController.text} berhasil ditambahkan')));

                    _nameController.text = '';
                    imageUrl = '';

                    Navigator.pop(context);
                  }
                },
                child: Text('Create'))
          ]),
        ),
      ),
    ));
  }
}
