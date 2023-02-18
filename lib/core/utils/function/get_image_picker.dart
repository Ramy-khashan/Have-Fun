 
import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> getImagePicker({required bool isCamera}) async { 
  XFile? xFile = await ImagePicker()
      .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);

  return File(xFile!.path);
}
