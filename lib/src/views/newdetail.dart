import 'package:flutter/material.dart';

import 'package:news/src/blocs/provider_bloc.dart';
import 'package:news/src/newsmodel/newsmodel.dart';
import '../widgets/comment.dart';
import 'dart:async';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('News detail'),
        ),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemwithcomments,
      builder: (context, AsyncSnapshot<Map<int, Future<NewsModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('loading');
        }
        final ItemFuture = snapshot.data[itemId];
        return FutureBuilder(
          future: ItemFuture,
          builder: (context, itemsnapshot) {
            if (!itemsnapshot.hasData) {
              return Center(child:CircularProgressIndicator());
            }
            return buildList(itemsnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildTitle(NewsModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildList(NewsModel item, Map<int, Future<NewsModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));
    final commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 1,

      );
    }).toList();
    children.addAll(commentsList);
    return ListView(
      children: children,
    );
  }
}
