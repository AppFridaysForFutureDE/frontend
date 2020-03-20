class TimeAgoUtil {
  static String render(DateTime time) {
    int diffInSeconds = DateTime.now().difference(time).inSeconds;
    if (diffInSeconds < 60) {
      return '$diffInSeconds Sek.';
    } else if (diffInSeconds < 60 * 60) {
      return '${(diffInSeconds / 60).floor()} Min.';
    } else if (diffInSeconds < 60 * 60 * 24) {
      return '${(diffInSeconds / 60 / 60).floor()} Std.';
    }
    return '${(diffInSeconds / 60 / 60 / 24).floor()} Tag.';
  }
}
