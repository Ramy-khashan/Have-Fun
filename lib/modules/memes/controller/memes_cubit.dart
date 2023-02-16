
import 'package:flutter_bloc/flutter_bloc.dart';

part 'memes_state.dart';

class MemesCubit extends Cubit<MemesState> {
  MemesCubit() : super(MemesInitial());
}
