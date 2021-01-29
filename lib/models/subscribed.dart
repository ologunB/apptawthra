class Subscribed {
  String _package;
  String _status;
  String _program;
  String _text;
  List _images;
  String _desc;
  String _starting;
  String _price;
  int _period;
  String _timeStamp;
  String _uid;
  int _id;
  int _noOftweets;
  String _username;
  String _accessToken;
  String _accessTokenSecret;

  String get package => _package;

  String get startTime => _starting;

  String get price => _price;

  String get status => _status;

  String get text => _text;

  String get program => _program;

  int get noOftweets => _noOftweets;

  String get desc => _desc;

  String get username => _username;

  int get period => _period;

  String get timeStamp => _timeStamp;

  String get accessToken => _accessToken;

  String get accessTokenSecret => _accessTokenSecret;

  int get id => _id;

  String get uid => _uid;

  List get images => _images;

  Subscribed.map(json) {
    this._package = json["package_name"];
    this._program = json["program"];
    this._username = json["username"];
    this._text = json["tweet_text"];
    this._noOftweets = json["number_of_tweets_per_day"];
    this._starting = json["scheduled_at"];
    this._images = json["images"];
    this._accessToken = json["access_token"];
    this._accessTokenSecret = json["access_token_secret"];
    this._price = json["price"];
    this._status = json["status"];
    this._period = json["period"];
    this._desc = json["desc"] ?? "";
    this._timeStamp = json["Timestamp"].toString();
    this._uid = json["uid"];
    this._id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_name'] = this.package;
    data['program'] = this.program;
    data['username'] = this.username;
    data['tweet_text'] = this.text;
    data['number_of_tweets_per_day'] = this.noOftweets;
    data['scheduled_at'] = this.startTime;
    data['images'] = this.images;
    data['access_token'] = this.accessToken;
    data['access_token_secret'] = this.accessTokenSecret;
    data['price'] = this.price;
    data['status'] = this.status;
    data['period'] = this.period;
    data['desc'] = this.desc;
    data['Timestamp'] = this.timeStamp;
    data['uid'] = this.uid;
    data['id'] = this.id;
    return data;
  }
}
