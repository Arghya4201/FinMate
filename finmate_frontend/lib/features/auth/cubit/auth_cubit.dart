import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;

  AuthCubit(this._repo) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final tokens = await _repo.login(email, password);
      emit(AuthSuccess(tokens['access'], tokens['refresh']));
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> register(String email, String username, String password, String name) async {
    emit(AuthLoading());
    try {
      await _repo.register(email, username, password, name);
      emit(AuthRegistered());
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  void logout() => emit(AuthInitial());
}
