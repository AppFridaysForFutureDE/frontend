class TimeAgoUtil {
  static String render(DateTime time, {DateTime now}) {
    now ??= DateTime.now();

    int diffInMinutes = now.difference(time).inMinutes;
    if (diffInMinutes < 2) {
      return '1 Min.';
    } else if (diffInMinutes < 60) {
      return '$diffInMinutes Min.';
    } else if (diffInMinutes < 60 * 24) {
      return '${(diffInMinutes / 60).floor()} Std.';
    } else if (diffInMinutes < 60 * 24 * 2) {
      return '1 Tag';
    }
    return '${(diffInMinutes / 60 / 24).floor()} Tagen';
  }
}
