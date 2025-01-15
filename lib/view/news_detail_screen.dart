import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsImage,
      newsTitle,
      newsDate,
      author,
      description,
      content,
      source;
  NewsDetailScreen(
      {super.key,
      required this.newsImage,
      required this.newsTitle,
      required this.newsDate,
      required this.author,
      required this.description,
      required this.content,
      required this.source});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    final format = DateFormat('MMMM dd YYYY');
    DateTime dateTime = DateTime.parse(widget.newsDate);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            height: height * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40)
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newsImage,
                fit: BoxFit.cover,
                placeholder: (context, ulr) => Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Container(
            height: height * 0.6,
            margin: EdgeInsets.only(top: height * 0.4),
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(40)
              ),
            ),
            child: ListView(
              children: [
                Text(widget.newsTitle, style: GoogleFonts.poppins(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w700),),
                SizedBox(height: height * 0.02,),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(widget.source,style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),)),
                    Text(format.format(dateTime) ,style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),),

                  ],
                ),
                SizedBox(height: height * 0.03,),
                Text(widget.description, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
