import 'package:bloc/bloc.dart';

class SearchFunctionCubit extends Cubit<bool> {
  SearchFunctionCubit() : super(false);

  void searching(bool searching) => emit(searching);
}
