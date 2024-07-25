import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  // const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterEvent(
    this.name, {
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}