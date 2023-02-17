import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'upload_memes_state.dart';

class UploadMemesCubit extends Cubit<UploadMemesState> {
  UploadMemesCubit() : super(UploadMemesInitial());
  static UploadMemesCubit get(context) => BlocProvider.of(context);
  late XFile imageXfile;
  File? imageFile;
}
