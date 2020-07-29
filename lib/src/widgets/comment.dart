import 'package:flutter/material.dart';
import 'package:news/src/widgets/Loading_container.dart';
import 'dart:async';
import '../newsmodel/newsmodel.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final int depth;
  final Map<int, Future<NewsModel>> itemMap;
  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<NewsModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        final children = <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(right: 16, left: depth * 16.0),
            title: buildText(snapshot.data),
            subtitle: snapshot.data.by == ''
                ? Text('Deleted')
                : Text(snapshot.data.by),
          ),
          Divider(),
        ];
        snapshot.data.kids.forEach(
          (kidId) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              ),
            );
          },
        );
        return Column(
          children: children,
        );
      },
    );
  }

  buildText(NewsModel news) {
    final text = news.text
        .replaceAll('&#x27', "'")
        .replaceAll('<P>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
