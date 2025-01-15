import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:world_news/view/categories_screen.dart';
import 'package:world_news/view/news_detail_screen.dart';
import '../model/General_News_Model.dart';
import '../model/news_header_model.dart';
import '../view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, alJazeera, cnn }

class _HomeScreenState extends State<HomeScreen> {
  FilterList? selectedMenu;
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd YYYY');
  String name = "bbc-news";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset(
            "assets/images/category_icon.png",
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
              onSelected: (FilterList item) {
                setState(() {
                  selectedMenu = item;
                  switch (item) {
                    case FilterList.bbcNews:
                      name = "bbc-news";
                      break;
                    case FilterList.aryNews:
                      name = "ary-news";
                      break;
                    case FilterList.alJazeera:
                      name = "al-jazeera-english";
                      break;
                    case FilterList.independent:
                      name = "independent";
                      break;
                    case FilterList.reuters:
                      name = "reuters";
                      break;
                    case FilterList.cnn:
                      name = "cnn";
                      break;
                  }
                });
              },
              initialValue: selectedMenu,
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<FilterList>>[
                    const PopupMenuItem(
                        value: FilterList.bbcNews, child: Text('BBC News')),
                    const PopupMenuItem(
                        value: FilterList.aryNews, child: Text('ARY News')),
                    const PopupMenuItem(
                        value: FilterList.alJazeera, child: Text('Al-Jazeera')),
                    const PopupMenuItem(
                      value: FilterList.reuters,
                      child: Text('Reuters'),
                    ),
                    const PopupMenuItem(
                      value: FilterList.cnn,
                      child: Text('CNN'),
                    ),
                  ]),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeaderModel>(
              future: newsViewModel.fetchNewsChannelHeadlineApi(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final article = snapshot.data!.articles;
                  return ListView.builder(
                      itemCount: article!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                            article[index].publishedAt.toString());
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                        newsImage: article[index].urlToImage.toString(),
                                        newsTitle: article[index].title.toString(),
                                        newsDate: article[index].publishedAt.toString(),
                                        author: article[index].author.toString(),
                                        description: article[index].description.toString(),
                                        content: article[index].content.toString(),
                                        source: article[index].source!.name.toString())));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // top container for showing images
                                Container(
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * 0.02,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          article[index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: spinKit2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: const EdgeInsets.all(15),
                                      height: height * 0.22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(
                                              article[index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  article[index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(19.0),
            child: FutureBuilder<GeneralNewsModel>(
              future: newsViewModel.fetchCatogoriesNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final article = snapshot.data!.articles;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: article!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                            article[index].publishedAt.toString());
                        return Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      article[index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  height: height * 0.18,
                                  width: width * 0.3,
                                  placeholder: (context, url) => Container(
                                    child: spinKit2,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * 0.18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        article[index].title.toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            article[index]
                                                .source!
                                                .name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitCircle(
  size: 50,
  color: Colors.amber,
);
