part of 'source_bloc.dart';

abstract class SourceState extends Equatable {
  const SourceState();
}

class SourceInitial extends SourceState {
  @override
  List<Object> get props => [];
}

class GetSourceListLoading extends SourceState {
  @override
  List<Object?> get props => [];
}

class GetSourceListSuccess extends SourceState {
  final List<Source> sources;

  GetSourceListSuccess({required this.sources});

  @override
  List<Object?> get props => [sources];
}

class GetSourceListError extends SourceState {
  final String message;

  GetSourceListError({required this.message});

  @override
  List<Object?> get props => [message];
}
