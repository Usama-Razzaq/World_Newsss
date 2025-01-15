import 'package:world_news/repository/news_repository.dart';

import '../model/General_News_Model.dart';
import '../model/news_header_model.dart';

class NewsViewModel{
  final _rep = NewsRepository();

  Future<NewsChannelHeaderModel> fetchNewsChannelHeadlineApi(String channelName) async{
    final response = await _rep.fetchNewsChannelHeadlineApi(channelName);
    return response;
  }

  Future<GeneralNewsModel> fetchCatogoriesNewsApi(String category) async{
    final response = await _rep.fetchCatogoriesNewsApi(category);
    return response;
  }
}