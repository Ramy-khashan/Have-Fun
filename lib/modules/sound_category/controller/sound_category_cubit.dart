import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sound_category_state.dart';

class SoundCategoryCubit extends Cubit<SoundCategoryState> {
  SoundCategoryCubit() : super(SoundCategoryInitial());
}
