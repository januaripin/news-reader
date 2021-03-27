import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class HttpFailure extends Failure {}

class ResponseFailure extends Failure {
  final int error;
  final String message;

  ResponseFailure({
    this.error = 0,
    this.message = ""
  });

  @override
  List<Object> get props => [error, message];
}

class NoInternetFailure extends Failure {}
