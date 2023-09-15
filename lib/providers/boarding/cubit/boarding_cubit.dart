import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'boarding_state.dart';

class BoardingCubit extends Cubit<BoardingState> {
  BoardingCubit() : super(BoardingInitial());

  static BoardingCubit get(context) => BlocProvider.of(context);

  int? selectedOption;

  selectOption(int selection) {
    selectedOption = selection;
    emit(BoardingInitial());
  }
}
