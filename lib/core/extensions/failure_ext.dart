import 'package:news_reader_app/core/errors/failures.dart';

extension FailureExt on Failure {
  String message() {
    switch (runtimeType) {
      case HttpFailure:
        return 'Kesalahan server';
      case ResponseFailure:
        return (this as ResponseFailure).message;
      case NoInternetFailure:
        return 'Silakan periksa koneksi internet Anda';
      default:
        return 'Unexpected error';
    }
  }
}