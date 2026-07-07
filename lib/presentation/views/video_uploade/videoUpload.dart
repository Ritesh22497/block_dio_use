import 'dart:io';

import 'package:block_dio_use/data/models/uploadModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() =>
      _UploadVideoScreenState();
}

class _UploadVideoScreenState
    extends State<UploadVideoScreen> {

  File? videoFile;

  final captionController =
      TextEditingController();

  Future<void> pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        videoFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        Provider.of<UploadVideoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Reel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            GestureDetector(
              onTap: pickVideo,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Center(
                  child: Text(
                    videoFile == null
                        ? "Select Video"
                        : "Video Selected",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: "Caption",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: vm.loading
                  ? null
                  : () async {

                      if (videoFile == null) return;

                      await vm.uploadVideo(
                        videoFile!,
                        captionController.text,
                      );

                      Navigator.pop(context);
                    },
              child: vm.loading
                  ? const CircularProgressIndicator()
                  : const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}