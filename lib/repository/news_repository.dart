import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/General_News_Model.dart';
import '../model/news_header_model.dart';

class NewsRepository {


  Future<NewsChannelHeaderModel> fetchNewsChannelHeadlineApi(String channelName) async {
    String url =
    "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=faa8df8a03184455a6353e74c6f1c2f0";
    print(url);
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeaderModel.fromJson(body);
    }
    throw Exception("error");
  }

  Future<GeneralNewsModel> fetchCatogoriesNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=${category}&apiKey=faa8df8a03184455a6353e74c6f1c2f0";
    print(url);
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return GeneralNewsModel.fromJson(body);
    }
    throw Exception("error");
  }


}