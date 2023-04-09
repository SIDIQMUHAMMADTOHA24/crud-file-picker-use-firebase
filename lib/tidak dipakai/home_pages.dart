import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  PlatformFile? pickedFiles;
  UploadTask? uploadTask;
  selectFiles() async {
    final resault = await FilePicker.platform.pickFiles();
    if (resault != null) {
      pickedFiles = resault.files.first;
      setState(() {});
    }
  }

  uploadFiles() async {
    final path = 'files/${pickedFiles!.name}';
    final file = File(pickedFiles!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('link download : $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 300,
              child: pickedFiles != null
                  ? Image.file(File(pickedFiles!.path!))
                  : Container(),
            ),
            ElevatedButton(
                onPressed: () => selectFiles(), child: Text('Select Files')),
            ElevatedButton(
                onPressed: () => uploadFiles(), child: Text('Upload Files')),
            buildProgres()
          ]),
        ),
      ),
    );
  }

  Widget buildProgres() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            double progres = data!.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(fit: StackFit.expand, children: [
                LinearProgressIndicator(
                  value: progres,
                  // backgroundColor: Colors.green,
                  color: Colors.green,
                ),
                Center(child: Text('${(100 * progres).toInt()} %'))
              ]),
            );
          } else {
            return SizedBox(
              height: 30,
            );
          }
        },
      );
}
