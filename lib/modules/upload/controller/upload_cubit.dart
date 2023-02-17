  
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../upload_video/view/upload_video.dart';
import '../../upload_memes/view/upload_memes.dart';
import '../view/widgets/upload_music.dart'; 
part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadInitial());

  static UploadCubit get(context) => BlocProvider.of(context);
  List<String> tabBarTitle = ["Video", "Music", "Memes"];
  List<Widget> pages = const [
    UploadVideoScreen(),
    UploadMusicPart(),
    UploadMemesScreen()
  ];
}
