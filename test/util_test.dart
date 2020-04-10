import 'package:test/test.dart';
import 'package:app/util/time_ago.dart';

void main() {
  group('TimeAgoUtil', () {
    final DateTime start = DateTime(2019);
    test('less than one minute', () {
      expect(TimeAgoUtil.render(start, 
              now: start.add(Duration(seconds: 1))),
          '1 Min.');
    });
    test('less than two minutes', () {
      expect(TimeAgoUtil.render(start, 
              now: start.add(Duration(minutes: 1, seconds: 59))),
          '1 Min.');
    });
    test('two minutes', () {
      expect(TimeAgoUtil.render(start, 
              now: start.add(Duration(minutes: 2))),
          '2 Min.');
    });
    test('less than one hour', () {
      expect(
          TimeAgoUtil.render(start,
              now: start.add(Duration(minutes: 59, seconds: 59))),
          '59 Min.');
    });
    test('less than one day', () {
      expect(
          TimeAgoUtil.render(start,
              now: start.add(Duration(hours: 23, minutes: 59, seconds: 59))),
          '23 Std.');
    });
    test('one day', () {
      expect(
          TimeAgoUtil.render(start,
              now: start.add(Duration(days: 1))),
          '1 Tag');
    });
    test('less than two days', () {
      expect(
          TimeAgoUtil.render(start,
              now: start.add(Duration(days: 1, hours: 23, seconds: 59))),
          '1 Tag');
    });
    test('two days', () {
      expect(
          TimeAgoUtil.render(start,
              now: start.add(Duration(days: 2))),
          '2 Tagen');
    });
  });
}
