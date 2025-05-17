import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_tracking_app/core/constants/constants.dart';
import 'package:order_tracking_app/features/auth/data/models/user_model.dart';
import 'package:order_tracking_app/features/auth/data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> loginUser({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await _authRepo.loginUser(email: email, password: password);
    result.fold((error){
      emit(AuthFailure(error));
    }, (userModel){
      UserData.userModel = userModel;
      emit(AuthSuccess("Login In Successfully"));
    });
  }

  Future<void> registerUser({required String userName, required String email, required String password}) async {
    emit(AuthLoading());
    final result = await _authRepo.registerUser(userName: userName, email: email, password: password);
    result.fold((error){
      emit(AuthFailure(error));
    }, (message){
      emit(AuthSuccess(message));
    });
  }
}
