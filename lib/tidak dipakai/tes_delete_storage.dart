import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TesDelete extends StatefulWidget {
  const TesDelete({super.key});

  @override
  State<TesDelete> createState() => _TesDeleteState();
}

class _TesDeleteState extends State<TesDelete> {
  PlatformFile? pickedFiles;

  String imageUrl = '';
  Reference? uploadedFileRef;

  getFiles() async {
    final resault = await FilePicker.platform.pickFiles();
    if (resault != null) {
      pickedFiles = resault.files.first;
      setState(() {});
    }
    uploadedFileRef = await uploadFiles();
  }

  //!upload files
  Future<Reference> uploadFiles() async {
    final ref =
        FirebaseStorage.instance.ref().child('files/${pickedFiles!.name}');
    await ref.putFile(File(pickedFiles!.path!));
    print('upload berhasil');
    return ref;
  }

  deleteImages() async {
    try {
      if (uploadedFileRef != null) {
        await uploadedFileRef!.delete();
        print('berhasil');
      }
    } catch (e) {
      print(e.toString());
      print('gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(children: [
            SizedBox(
              width: 100,
              height: 100,
              child: pickedFiles != null
                  ? Image.file(File(pickedFiles!.path!))
                  : Container(),
            ),
            ElevatedButton(onPressed: () => getFiles(), child: Text('Files')),
            ElevatedButton(
                onPressed: () => deleteImages(), child: Text('Delete'))
          ]),
        ),
      ),
    );
  }
}
