import 'package:flutter/material.dart';
import 'package:news_app/resources/article_list.dart';
import 'package:news_app/resources/article_model.dart';
import 'package:news_app/screens/home_screen.dart';

class CategoryScreen extends StatefulWidget {

  final String cName;

  CategoryScreen({this.cName});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _loading = true;
  List<ArticleModel> articles = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    ArticleList articleList = ArticleList();

    await articleList.getNews(widget.cName);
    articles = articleList.news;
    setState(() {
      _loading = false;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('News'),
            Text(
              'App',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return BlogTile(
                      title: articles[index].title,
                      imgUrl: articles[index].urlToImage,
                      desc: articles[index].desc,
                      url: articles[index].url,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
