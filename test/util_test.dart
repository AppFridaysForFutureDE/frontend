import 'package:test/test.dart';
import 'package:app/util/time_ago.dart';

void main() {
  group('TimeAgoUtil', () {
    test('Render Sekunden', () {
      var start = DateTime(2019);
      expect(TimeAgoUtil.render(start, now: start.add(Duration(seconds: 21))),
          '21 Sek.');
    });
    test('Render Minuten', () {
      var start = DateTime(2019);
      expect(
          TimeAgoUtil.render(start,
              now: start.add(Duration(seconds: 21, minutes: 43))),
          '43 Min.');
    });
    test('Render Stunden', () {
      var start = DateTime(2019);
      expect(
          TimeAgoUtil.render(start,
              now: start.add(Duration(hours: 7, minutes: 59))),
          '7 Std.');
    });
    test('Render Tage', () {
      expect(
          TimeAgoUtil.render(DateTime(2019), now: DateTime(2020)), '365 Tag.');
    });
  });
}
