import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/resources/article_list.dart';
import 'package:news_app/resources/article_model.dart';
import 'package:news_app/resources/category_model.dart';
import 'package:news_app/resources/category_list.dart';
import 'package:news_app/screens/article_screen.dart';
import 'package:news_app/screens/category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categoryList = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categoryList = getCategories();
    getNews();
  }

  getNews() async {
    ArticleList articleList = ArticleList();
    await articleList.getNews("");
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
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: categoryList.length,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                              url: categoryList[index].categoryUrl,
                              name: categoryList[index].categoryName,
                            );
                          },
                        ),
                      ),
                      Container(
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
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String url;
  final String name;

  CategoryTile({this.url, this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("Category name is $name");
        Navigator.push(context, MaterialPageRoute(builder:(context)=>CategoryScreen(
          cName: name.toLowerCase(),
        )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Stack(
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl:url,
                  width: 120.0,
                  height: 70.0,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 120.0,
              height: 70.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.black38.withOpacity(.2),
              ),
              alignment: Alignment.center,
              child: Text(
                name,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String url;

  BlogTile({this.imgUrl, this.title, this.desc, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleScreen(
              blogUrl: url,
            ),
          ),
        );
      },
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20.0),
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    width: double.infinity,
                    image: NetworkImage(imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  title,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(bottom: 0.0),
                child: Text(
                  desc,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          )),
    );
  }
}
