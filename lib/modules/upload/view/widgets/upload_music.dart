import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:havefun/core/widgets/app_button.dart';

class UploadMusicPart extends StatelessWidget {
  UploadMusicPart({Key? key}) : super(key: key);

  FileType pickingType = FileType.audio;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AppButton(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
              );
            },
            head: "getAudio"));
  }
}
