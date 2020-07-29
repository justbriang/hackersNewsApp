import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
import 'package:news/src/widgets/newslist_ltile.dart';
import 'package:news/src/widgets/refresh_indicator.dart';

import '../blocs/stories_provider.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    // Navigator.pushNamed(context, '/');
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Hackers News feed'),
        ),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Refresh(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                bloc.fetchItem(snapshot.data[index]);

                return NewsListTile(
                  snapshot.data[index],
                );
              },
            ),
          );
        });
  }
}
