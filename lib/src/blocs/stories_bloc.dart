import 'package:rxdart/rxdart.dart';
import '../newsmodel/newsmodel.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  //subject(streamcontroller)
  final _topIds = PublishSubject<List<int>>();
  final _repository = Repository();
  final _itemsOutput = BehaviorSubject<Map<int, Future<NewsModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //getters to streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<NewsModel>>> get items => _itemsOutput.stream;

  //getter to sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<NewsModel>> cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<NewsModel>>{},
    );
  }

  clearcache() {
  
    return _repository.clearCache();
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
