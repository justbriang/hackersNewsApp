import 'package:news/src/resources/hackersprovider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchTopIds returns a list of ids', () async {
    //set up
    final newapiprovider = NewsApiProvider();
    newapiprovider.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newapiprovider.fetchTopIds();

    //expectation
    expect(ids, [1, 2, 3, 4]);
  });
  test('fetch item returns an item model', () async {
    final newsapiprovider = NewsApiProvider();
    newsapiprovider.client = MockClient((request) async {
      final jsonmap = {'id': 123};
      return Response(json.encode(jsonmap), 200);
    });
    final item =await newsapiprovider.fetchItem(999);

    expect(item.id, 123);
  });
}
