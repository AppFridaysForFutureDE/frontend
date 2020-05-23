/**
 * A class that represents a Event which is live at the Moment. The url points to a livestream.
 */
class LiveEvent{
  /**
   * Indicates if there is a current liveevent
   */
  bool isActive;

  /**
   * Indicates if the app schould launch the first Strike Action from the Netzstrike section in the app or
   * open the url
   */
  bool inApp;

  /**
   * The title of the Live event.
   */
  String actionText;

  /**
   * The url of the live event. Only relevant if inApp == false
   */
  String actionUrl;
  LiveEvent(this.isActive,this.inApp,this.actionText,this.actionUrl);
  LiveEvent.fromJSON(Map<String, dynamic> json ){
    isActive = json["isActive"];
    inApp = json["inApp"];
    actionUrl = json["actionUrl"];
    actionText = json["actionText"];

  }
}