import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils', () {
    test('routeObserver should be initialized', () {
      expect(routeObserver, isA<RouteObserver<ModalRoute>>());
    });

    test('routeObserver should be singleton', () {
      final observer1 = routeObserver;
      final observer2 = routeObserver;
      expect(identical(observer1, observer2), true);
    });
  });
}
