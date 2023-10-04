import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'boarding_state.dart';

class BoardingCubit extends Cubit<BoardingState> {
  BoardingCubit() : super(BoardingInitial());

  static BoardingCubit get(context) => BlocProvider.of(context);
  SharedPreferences? sharedPreferences;
  int? selectedOption;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    selectedOption = sharedPreferences!.getInt('selectedOption');
  }

  selectOption(int selection) {
    selectedOption = selection;
    sharedPreferences!.setInt('selectedOption', selection);
    emit(BoardingInitial());
  }
}
