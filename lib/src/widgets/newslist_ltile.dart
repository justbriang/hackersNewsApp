import 'package:flutter/material.dart';
import 'package:news/src/widgets/Loading_container.dart';
import '../newsmodel/newsmodel.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemid;
  NewsListTile(this.itemid);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<NewsModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemid],
          builder: (context, AsyncSnapshot<NewsModel> itemsnapshot) {
            if (itemsnapshot.hasData) {
              return buildTile(context, itemsnapshot.data);
            }
            return LoadingContainer();
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, NewsModel newsModel) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(newsModel.title),
          onTap: () {
            Navigator.pushNamed(context, '/${newsModel.id}');
          },
          subtitle: Text('${newsModel.score} points'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${newsModel.descendants}'),
            ],
          ),
        ),
        Divider(
          height: 5.0,
        ),
      ],
    );
  }
}
