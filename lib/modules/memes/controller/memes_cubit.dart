 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../model/memes_model.dart';

part 'memes_state.dart';

class MemesCubit extends Cubit<MemesState> {
  MemesCubit() : super(MemesInitial());
  static MemesCubit get(context) => BlocProvider.of<MemesCubit>(context);
  List<MemesModel> memesList = [];
  bool isLoadingMemes = false;
  getMemes() async {
    isLoadingMemes = true;
    memesList = [];
    emit(LoadingMemesState());
    try {
      await FirebaseFirestore.instance.collection("memes").get().then(
        (value) {
          if (value.docs.isEmpty) {
            memesList = [];
          } else {
            for (var element in value.docs) {
              memesList.add(MemesModel.fromJson(element.data()));
            }
          }
          isLoadingMemes = false;
          emit(SuccessMemesState());
        },
      ).onError((error, stackTrace) {
        isLoadingMemes = false;
        memesList = [];
        emit(FaildMemesState());
      });
    } catch (e) {
      isLoadingMemes = false;
      memesList = [];

      emit(FaildMemesState());
    }
  }
}
