import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    final buttonFinder = find.byValueKey('increment');
    final counterTextFinder = find.byValueKey('counter');
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async => driver?.close());


    test('increments the counter', () async {
      await driver?.tap(buttonFinder, timeout: Duration(seconds: 10));
      expect(await driver?.getText(counterTextFinder), "1");
    });

    // test('increments the counter', () async {
    //   await driver?.tap(buttonFinder, timeout: Duration(seconds: 10));
    //   expect(await driver?.getText(counterTextFinder), "2");
    // });
    //
    // test('increments the counter', () async {
    //   await driver?.tap(buttonFinder, timeout: Duration(seconds: 10));
    //   expect(await driver?.getText(counterTextFinder), "3");
    // });

    // for (int i=0; i<20; i++) {
    //   test('increments the counter', () async {
    //     await driver?.tap(buttonFinder, timeout: Duration(seconds: 10));
    //   });
    // }
  });
}