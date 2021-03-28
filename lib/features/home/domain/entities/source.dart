import 'package:equatable/equatable.dart';

class Source extends Equatable {
  final String id;
  final String name;

  Source(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}