import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../newsmodel/newsmodel.dart';
import 'repository.dart';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();
  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_root/topstories.json?');
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<NewsModel> fetchItem(int id) async {
    final response = await client.get('$_root/item/$id.json?');
    final parsedJson = json.decode(response.body);
    return NewsModel.fromJson(parsedJson);
  }
}
