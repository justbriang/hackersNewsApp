import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';

class Refresh extends StatelessWidget {
  const Refresh({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearcache();
        await bloc.fetchTopIds();
      },
    );
  }
}
