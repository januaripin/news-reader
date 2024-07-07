import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_reader_app/features/article_detail/presentation/pages/article_detail_page.dart';
import 'package:news_reader_app/features/discovery/presentation/bloc/news_by_keyword_bloc.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';
import 'package:news_reader_app/features/home/presentation/widgets/news_item.dart';
import 'package:news_reader_app/service_locator.dart';
import 'package:news_reader_app/utility.dart';

class DiscoveryPage extends StatefulWidget {
  DiscoveryPage({Key? key}) : super(key: key);

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  NewsByKeywordBloc _bloc = sl<NewsByKeywordBloc>();

  List<Article> _articles = List.empty(growable: true);
  int _page = 1;
  int _pageSize = 20;
  bool _isLastPage = false;
  String _keyword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Discovery',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (keyword) {
                  setState(() {
                    _keyword = keyword;
                    _page = 1;
                    _articles.clear();
                    if (_keyword.isEmpty) {
                      _bloc.add(GetNewsByKeywordStop());
                    } else {
                      _bloc.add(
                        GetNewsByKeywordEvent(
                          keyword: _keyword,
                          page: _page,
                          pageSize: _pageSize,
                        ),
                      );
                    }
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: "Enter the keyword",
                ),
              ),
            ),
            Expanded(
              child: BlocProvider(
                create: (_) => _bloc,
                child: BlocBuilder<NewsByKeywordBloc, NewsByKeywordState>(
                  builder: (context, state) {
                    if (state is GetNewsByKeywordError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Utility.instance.showInfoDialog(context, state.message);
                      });
                    } else if (state is GetNewsByKeywordLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is GetNewsByKeywordCanceled) {
                      return Container();
                    } else if (state is GetNewsByKeywordSuccess) {
                      _articles.addAll(state.articles);
                      _isLastPage = state.articles.length < _pageSize;

                      if (!_isLastPage) {
                        _page++;
                      }
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          if (_keyword.isNotEmpty) {
                            _page = 1;
                            _articles.clear();
                            _bloc.add(
                              GetNewsByKeywordEvent(
                                keyword: _keyword,
                                page: _page,
                                pageSize: _pageSize,
                              ),
                            );
                          }
                        });
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _articles.length,
                        itemBuilder: (context, index) {
                          if (index == _articles.length - 5 && !_isLastPage) {
                            _bloc.add(
                              GetNewsByKeywordEvent(
                                keyword: _keyword,
                                page: _page,
                                pageSize: _pageSize,
                              ),
                            );
                          }

                          return NewsItem(
                            article: _articles[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ArticleDetailPage(
                                      url: _articles[index].url),
                                  settings:
                                      RouteSettings(name: '/article-detail'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
