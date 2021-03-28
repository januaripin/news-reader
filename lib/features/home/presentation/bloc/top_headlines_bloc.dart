import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_top_headlines.dart';
import 'package:news_reader_app/core/extensions/failure_ext.dart';

part 'top_headlines_event.dart';

part 'top_headlines_state.dart';

class TopHeadlinesBloc extends Bloc<TopHeadlinesEvent, TopHeadlinesState> {
  final GetTopHeadlines getTopHeadlines;

  TopHeadlinesBloc(this.getTopHeadlines) : super(TopHeadlinesInitial());

  @override
  Stream<TopHeadlinesState> mapEventToState(
    TopHeadlinesEvent event,
  ) async* {
    if (event is GetTopHeadlinesEvent) {
      yield GetTopHeadlinesLoading();
      final result = await getTopHeadlines.call(Params(sourceId: event.sourceId, page: event.page, pageSize: event.pageSize));
      yield result.fold(
        (l) => GetTopHeadlinesError(message: l.message()),
        (r) => GetTopHeadlinesSuccess(topHeadlines: r),
      );
    }
  }
}
