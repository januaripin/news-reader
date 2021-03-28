import 'package:flutter/material.dart';
import 'package:news_reader_app/core/utils/dt.dart';
import 'package:news_reader_app/features/home/domain/entities/article.dart';

class NewsItem extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const NewsItem({Key? key, required this.article, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                if (article.urlToImage.startsWith("http"))
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.network(
                      article.urlToImage,
                      height: 192,
                    ),
                  ),
                if (article.urlToImage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 192,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      color: Colors.black.withOpacity(0.60),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    article.title,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'by ${article.author == '' ? 'anonymous' : article.author}',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  )),
                  Text(
                      DT.toHuman(
                        DateTime.parse(
                          article.publishedAt,
                        ).millisecondsSinceEpoch,
                      ),
                      style: Theme.of(context).textTheme.caption)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, bottom: 24, right: 16, left: 16),
              child: Text(
                article.content,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
