part of 'source_bloc.dart';

abstract class SourceEvent extends Equatable {
  const SourceEvent();
}

class GetSourceListEvent extends SourceEvent {
  @override
  List<Object?> get props => [];
}
