import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/General_News_Model.dart';
import '../view_model/news_view_model.dart';
import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd YYYY');
  String categoryNews = "general";
  String categoryName = '';
  List<String> categoiresList = [
    "General",
    "Entertainment",
    "Wealth",
    "Sports",
    "Business",
    "Technology"
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoiresList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        categoryName = categoiresList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              color: categoryName == categoiresList[index]
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(categoiresList[index].toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 13)),
                          )),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<GeneralNewsModel>(
                future: newsViewModel.fetchCatogoriesNewsApi(categoryName),
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              article[index].source!.name.toString(),
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
            ),
          ],
        ),
      ),
    );
  }
}
