import 'newsDBprovider.dart';
import 'hackersprovider.dart';
import 'dart:async';
import '../newsmodel/newsmodel.dart';

class Repository {
  // NewsApiProvider newsApiProvider = NewsApiProvider();

  List<Source> sources = <Source>[NewsApiProvider(), newsDbProvider];
  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    var id;
    for (var source in sources) {
      id = source.fetchTopIds();

      if (id != null) {
        break;
      }
    }
    return id;
    // return sources[1].fetchTopIds();
  }

  Future<NewsModel> fetchItem(int id) async {
    NewsModel item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);

      if (item != null) {
        break;
      }
    }
    for (var cache in caches) {
      if (cache != source) cache.addItem(item);
    }
    return item;
  }

  clearCache() async {
    for (var cache in caches) await cache.clear();
  }
}

abstract class Source {
  Future<NewsModel> fetchItem(int id);
  Future<List<int>> fetchTopIds();
}

abstract class Cache {
  Future<int> addItem(NewsModel item);
  Future<int> clear();
}
