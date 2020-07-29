import 'package:flutter/material.dart';
import 'package:news/src/blocs/provider_bloc.dart';
import 'package:news/src/views/homepage.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/views/newdetail.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.red,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          title: 'Data Fetch',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesbloc = StoriesProvider.of(context);
          storiesbloc.fetchTopIds();
          return Homepage();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          final commentsbloc = CommentsProvider.of(context);
          commentsbloc.fetchItemWithComments(itemId);
          return NewsDetail(itemId: itemId);
        },
      );
    }
  }
}
