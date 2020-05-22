/**
 * A class that represents a Event which is live at the Moment. The url points to a livestream.
 */
class LiveEvent{
  /**
   * Indicates if there is a current liveevent
   */
  bool isLive;

  /**
   * Indicates if the app schould launch the first Strike Action from the Netzstrike section in the app or
   * open the url
   */
  bool inApp;

  /**
   * The title of the Live event.
   */
  String title;

  /**
   * The url of the live event. Only relevant if inApp == false
   */
  String url;
  LiveEvent(this.isLive,this.inApp,this.title,this.url);
  LiveEvent.fromJSON(Map<String, dynamic> json ){
    isLive = json["isActive"];
    inApp = json["inApp"];
    url = json["actionUrl"];
    title = json["actionText"];

  }
}