/**
 * A class that represents a Event which is live at the Moment. The url points to a livestream.
 */
class LiveEvent{
  bool isLive;
  bool inApp;
  String title;
  String url;
  LiveEvent(this.isLive,this.inApp,this.title,this.url);
}