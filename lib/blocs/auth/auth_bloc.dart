import 'package:dio/dio.dart';
import 'package:sanctum_mobile/blocs/auth/auth_event.dart';
import 'package:sanctum_mobile/blocs/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Dio _dio = Dio();

  AuthBloc() : super(AuthInitial()) {
    _dio.options.baseUrl = 'https://sanctum-new-production.up.railway.app/api';
    _dio.options.receiveTimeout = const Duration(milliseconds: 20000);
    _dio.options.connectTimeout = const Duration(milliseconds: 20000);

    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<RegisterEvent>(_onRegisterEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
      try {
        final response = await _dio.post(
          '/login',
          data: FormData.fromMap({
            'email': event.email,
            'password': event.password,
          }),
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
            sendTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
          ),
        );

        if (response.statusCode == 200 && response.data['status'] == true){
          final token= response.data['token'];
          emit(AuthSuccess(token: token));
          final sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences.setString('token', token);

        } else {
          emit(AuthFailure(message: response.data['message'] ?? 'An error occurred'));
        }
      } on DioException catch(e) {
        final errorMessage= e.response?.data['message'] ?? 'An error occurred';
        emit(AuthFailure(message: errorMessage));
      } catch(e) {
        emit(AuthFailure(message: 'An unknown error occurred'));
      }
    }

    Future<void> _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final sharedPreferences = await SharedPreferences.getInstance();
        final token = sharedPreferences.getString('token');
        if (token != null) {
          await _dio.get(
            '/logout',
            options: Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              sendTimeout: const Duration(milliseconds: 10000),
              receiveTimeout: const Duration(milliseconds: 10000),
            ),
          );
          await sharedPreferences.remove('token');
          emit(AuthInitial());
        } else {
          emit(AuthFailure(message: 'No token found'));
        }
      } on DioException catch(e) {
        emit(AuthFailure(message: 'Error: $e'));
      }
    }

    Future<void> _onRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final response = await _dio.post(
          '/register',
          data: FormData.fromMap({
            'name': event.name,
            'email': event.email,
            'password': event.password,
          }),
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
            sendTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
          ),
        );

        if (response.statusCode == 200 && response.data['status'] == true) {
          emit(AuthSuccess(token: response.data['token']));
        } else {
          emit(AuthFailure(message: response.data['message'] ?? 'An error occurred'));
          print(response.data['errors']);
        }
      } on DioException catch(e) {
        final errorMessage= e.response?.data['message'] ?? 'An error occurred';
        emit(AuthFailure(message: errorMessage));
      } catch(e) {
        emit(AuthFailure(message: 'An unknown error occurred'));
      }
    }

    Future<void> _onFetchUserEvent(FetchUserName event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final sharedPreferences = await SharedPreferences.getInstance();
        final token = sharedPreferences.getString('token');
        if (token != null) {
          final response = await _dio.get(
            '/showCurrent',
            options: Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              sendTimeout: const Duration(milliseconds: 10000),
              receiveTimeout: const Duration(milliseconds: 10000),
            ),
          );
          
          if (response.statusCode == 200){
            final userName = response.data['name'];
            emit(UserFetchSuccess(userName: userName));
          } else {
            emit(AuthFailure(message: 'Failed to load username'));
          }
        } else {
          emit(AuthFailure(message: 'No token found'));
        }
      } on DioException catch(e) {
        emit(AuthFailure(message: 'Error: $e'));
      }
    }
  }