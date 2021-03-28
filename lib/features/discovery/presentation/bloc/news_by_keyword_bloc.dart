import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_reader_app/features/discovery/domain/use_cases/get_news_by_keyword.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/core/extensions/failure_ext.dart';

part 'news_by_keyword_event.dart';
part 'news_by_keyword_state.dart';

class NewsByKeywordBloc extends Bloc<NewsByKeywordEvent, NewsByKeywordState> {
  final GetNewsByKeyword getNewsByKeyword;

  NewsByKeywordBloc(this.getNewsByKeyword) : super(NewsByKeywordInitial());

  @override
  Stream<NewsByKeywordState> mapEventToState(
    NewsByKeywordEvent event,
  ) async* {
    if (event is GetNewsByKeywordEvent) {
      yield GetNewsByKeywordLoading();
      final result = await getNewsByKeyword.call(Params(keyword: event.keyword, page: event.page, pageSize: event.pageSize));
      yield result.fold((l) => GetNewsByKeywordError(message: l.message()), (r) => GetNewsByKeywordSuccess(articles: r));
    } else if (event is GetNewsByKeywordStop) {
      yield GetNewsByKeywordCanceled();
    }
  }
}
