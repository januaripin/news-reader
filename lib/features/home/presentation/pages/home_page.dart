import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';
import 'package:news_reader_app/features/home/presentation/bloc/source_bloc.dart';
import 'package:news_reader_app/generated/l10n.dart';
import 'package:news_reader_app/service_locator.dart';
import 'package:news_reader_app/utility.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SourceBloc _sourceBloc = sl<SourceBloc>();
  String _selectedSourceId = "all";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: MultiBlocProvider(
            providers: [BlocProvider(create: (_) => _sourceBloc)],
            child: RefreshIndicator(
              onRefresh: () async {
                _sourceBloc.add(GetSourceListEvent());
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          child: Text(
                            'US ${S().app_name}',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<SourceBloc, SourceState>(
                      builder: (context, state) {
                        if (state is SourceInitial) {
                          _sourceBloc.add(GetSourceListEvent());
                        } else if (state is GetSourceListError) {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            Utility.instance
                                .showInfoDialog(context, state.message);
                          });
                        } else if (state is GetSourceListSuccess) {
                          final sources = List.empty(growable: true);
                          sources.add(Source("all", "All"));
                          sources.addAll(state.sources);

                          return Container(
                            height: 50,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              scrollDirection: Axis.horizontal,
                              itemCount: sources.length,
                              itemBuilder: (context, index) {
                                final source = sources[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: ChoiceChip(
                                    label: Text(
                                      source.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(color: Colors.grey[800]),
                                    ),
                                    selected: _selectedSourceId == source.id,
                                    selectedColor: Colors.grey[300],
                                    backgroundColor: Colors.grey,
                                    onSelected: (b) {
                                      setState(() {
                                        _selectedSourceId = source.id;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int i = 0; i < 4; i++)
                                Chip(
                                  label: Text('shimmer'),
                                )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
