part of 'news_by_keyword_bloc.dart';

abstract class NewsByKeywordState extends Equatable {
  const NewsByKeywordState();
}

class NewsByKeywordInitial extends NewsByKeywordState {
  @override
  List<Object> get props => [];
}

class GetNewsByKeywordLoading extends NewsByKeywordState {
  @override
  List<Object?> get props => [];
}

class GetNewsByKeywordSuccess extends NewsByKeywordState {
  final List<Article> articles;

  GetNewsByKeywordSuccess({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class GetNewsByKeywordError extends NewsByKeywordState {
  final String message;

  GetNewsByKeywordError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetNewsByKeywordCanceled extends NewsByKeywordState {
  @override
  List<Object?> get props => [];
}
