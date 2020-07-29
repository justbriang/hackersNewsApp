import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import '../newsmodel/newsmodel.dart';
import 'dart:async';

class CommentsBloc {
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<NewsModel>>>();
  final _repository = Repository();
  //getter to the streams
  Stream<Map<int, Future<NewsModel>>> get itemwithcomments =>
      _commentsOutput.stream;
  //getter to the sinks
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;
  //constructore to initialize the bloc
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }
  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<NewsModel>>>(
      (cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        cache[id].then(
          (NewsModel newsModel) {
            newsModel.kids.forEach((kidId) => fetchItemWithComments(kidId));
          },
        );
        return cache;
      },
      <int, Future<NewsModel>>{},
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
