import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UpdatePages extends StatefulWidget {
  UpdatePages(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.documentSnapshot});
  final String name;
  late String imageUrl;

  final DocumentSnapshot documentSnapshot;

  @override
  State<UpdatePages> createState() => _UpdatePagesState();
}

class _UpdatePagesState extends State<UpdatePages> {
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('person');
  final FirebaseStorage storage = FirebaseStorage.instance;

  PlatformFile? pickedFiles;
  String image = '';
  Reference? uploadedFileRef;

  //! get file
  getFiles() async {
    final resault = await FilePicker.platform.pickFiles();
    if (resault != null) {
      pickedFiles = resault.files.first;
      setState(() {});
    }
    await uploadFiles();
    print(image);
  }

  //!upload files
  uploadFiles() async {
    final path = 'files/${pickedFiles!.name}';
    final file = File(pickedFiles!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final snapshot = await ref.putFile(file).whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    image = urlDownload;
  }

  //! text Controller
  final _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _nameController.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(
              height: 100,
              width: 100,
              child: pickedFiles == null
                  ? Image.network(widget.imageUrl)
                  : Image.file(File(pickedFiles!.path!))),
          TextField(
            controller: _nameController,
            decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'nama'),
          ),
          ElevatedButton(
              onPressed: () {
                getFiles();
              },
              child: Text('File')),
          ElevatedButton(
              onPressed: () async {
                if (image.isNotEmpty) {
                  await _user.doc(widget.documentSnapshot.id).update({
                    'nama': _nameController.text,
                    'imageUrl': image,
                  });
                  await storage.refFromURL(widget.imageUrl).delete();
                }
                if (pickedFiles == null) {
                  await _user.doc(widget.documentSnapshot.id).update({
                    'nama': _nameController.text,
                    'imageUrl': widget.imageUrl,
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Update'))
        ]),
      ),
    );
  }
}
