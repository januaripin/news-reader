part of 'top_headlines_bloc.dart';

abstract class TopHeadlinesState extends Equatable {
  const TopHeadlinesState();
}

class TopHeadlinesInitial extends TopHeadlinesState {
  @override
  List<Object> get props => [];
}

class GetTopHeadlinesLoading extends TopHeadlinesState {
  @override
  List<Object?> get props => [];
}

class GetTopHeadlinesSuccess extends TopHeadlinesState {
  final List<Article> topHeadlines;

  GetTopHeadlinesSuccess({required this.topHeadlines});

  @override
  List<Object?> get props => [topHeadlines];
}

class GetTopHeadlinesError extends TopHeadlinesState {
  final String message;

  GetTopHeadlinesError({required this.message});

  @override
  List<Object?> get props => [message];
}
