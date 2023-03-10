import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageFirebase({required File imageFile,String folder="personalImag"}) async {
  int ranNum = Random().nextInt(10000000);
  String imageBasename = path.basename(imageFile.path) + ranNum.toString();

  var ref = FirebaseStorage.instance.ref().child("$folder/$imageBasename");
  await ref.putFile(
    File(imageFile.path),
  );
  return await ref.getDownloadURL();
}
