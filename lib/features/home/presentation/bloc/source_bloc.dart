import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_reader_app/core/extensions/failure_ext.dart';
import 'package:news_reader_app/core/usecases/usecase.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';
import 'package:news_reader_app/features/home/domain/use_cases/get_sources.dart';

part 'source_event.dart';

part 'source_state.dart';

class SourceBloc extends Bloc<SourceEvent, SourceState> {
  final GetSources getSources;

  SourceBloc(this.getSources) : super(SourceInitial());

  @override
  Stream<SourceState> mapEventToState(
    SourceEvent event,
  ) async* {
    if (event is GetSourceListEvent) {
      yield GetSourceListLoading();
      final result = await getSources(NoParams());
      yield result.fold((l) => GetSourceListError(message: l.message()),
          (r) => GetSourceListSuccess(sources: r));
    }
  }
}
