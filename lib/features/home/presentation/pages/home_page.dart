import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader_app/features/article_detail/presentation/pages/article_detail_page.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/domain/entities/source.dart';
import 'package:news_reader_app/features/home/presentation/bloc/source_bloc.dart';
import 'package:news_reader_app/features/home/presentation/bloc/top_headlines_bloc.dart';
import 'package:news_reader_app/features/home/presentation/widgets/news_item.dart';
import 'package:news_reader_app/features/home/presentation/widgets/source_item.dart';
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
  final TopHeadlinesBloc _topHeadlinesBloc = sl<TopHeadlinesBloc>();
  String _selectedSourceId = "all";

  List<Article> _articles = List.empty(growable: true);
  int _page = 1;
  int _pageSize = 20;
  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => _sourceBloc),
              BlocProvider(create: (_) => _topHeadlinesBloc),
            ],
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _page = 1;
                  _articles.clear();
                });
                _topHeadlinesBloc.add(
                  GetTopHeadlinesEvent(
                    sourceId: _selectedSourceId,
                    page: _page,
                    pageSize: _pageSize,
                  ),
                );
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
                          _page = 1;
                          _articles.clear();
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            _topHeadlinesBloc.add(GetTopHeadlinesEvent(
                                sourceId: _selectedSourceId,
                                page: _page,
                                pageSize: _pageSize));
                          });
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
                                return SourceItem(
                                  label: source.name,
                                  onSelected: (b) {
                                    _refreshPage(source.id);
                                  },
                                  selected: _selectedSourceId == source.id,
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
                  BlocBuilder<TopHeadlinesBloc, TopHeadlinesState>(
                    builder: (context, state) {
                      if (state is GetTopHeadlinesError) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          Utility.instance
                              .showInfoDialog(context, state.message);
                        });
                      } else if (state is GetTopHeadlinesSuccess) {
                        _articles.addAll(state.topHeadlines);
                        _isLastPage = state.topHeadlines.length < _pageSize;

                        if (!_isLastPage) {
                          _page++;
                        }
                      }

                      return _articles.length == 0
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index == _articles.length - 5 &&
                                      !_isLastPage) {
                                    _topHeadlinesBloc.add(GetTopHeadlinesEvent(
                                        sourceId: _selectedSourceId,
                                        page: _page,
                                        pageSize: _pageSize));
                                  }

                                  return NewsItem(
                                    article: _articles[index],
                                    onTap: () {
                                      debugPrint("Masuk ke sini");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ArticleDetailPage(
                                              url: _articles[index].url),
                                          settings: RouteSettings(
                                              name: '/article-detail'),
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: _articles.length,
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _refreshPage(sourceId) {
    setState(() {
      _selectedSourceId = sourceId;
      _page = 1;
      _articles.clear();
      _topHeadlinesBloc.add(
        GetTopHeadlinesEvent(
          sourceId: sourceId,
          page: _page,
          pageSize: _pageSize,
        ),
      );
    });
  }
}
