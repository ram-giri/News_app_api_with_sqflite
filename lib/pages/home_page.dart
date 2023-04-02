import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/pages/watch_later_page.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/services/db_service.dart';
import '../components/article_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cAuthor = TextEditingController();
  TextEditingController ctitle = TextEditingController();
  TextEditingController cdisc = TextEditingController();
  TextEditingController cUrlImage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var future = ApiService().getArticle();
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "News",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.watch_later,
                color: Colors.blue,
              ),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const WatchLaterPage()));
              },
            ),
          ],
          backgroundColor: Colors.white),
      body: FutureBuilder(
        future: future,
        builder: (BuildContext context, snapshot) {
          var allArticle = snapshot.data;
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: allArticle!.length,
              itemBuilder: (context, index) {
                var article = allArticle[index];
                return ArticleWidget(
                  article: article,
                  index: index,
                  positionedchild: TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 5)),
                    onPressed: () {
                      Article news = Article(
                        sourceName: article.sourceName,
                        author: article.author,
                        title: article.title,
                        description: article.description,
                        url: article.url,
                        urlToImage: article.urlToImage,
                        publishedAt: DateTime.parse(
                            article.publishedAt.toIso8601String()),
                        content: article.content,
                        sourceID: article.sourceID,
                      );
                      DBService.instance.addNews(news);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Added successfully', style: TextStyle(color: Colors.green),),
                        duration: Duration(milliseconds: 300),

                      ));
                    },
                    icon: const Icon(Icons.watch_later_outlined),
                    label: const Text('Watch Later'),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('No data found!'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
