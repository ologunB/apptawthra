class Subscribed {
  String _package;
  String _status;
  String _program;
  String _text;
  List _images;
  String _desc;
  String _starting;
  String _price;
  Map _account;
  String _tweetId;
  String _timeStamp;
  String _uid;
  String _noOftweets;

  String get package => _package;

  String get startTime => _starting;

  String get price => _price;

  String get status => _status;

  Map get account => _account;

  String get message => _text;

  String get program => _program;

  String get noOftweets => _noOftweets;

  String get desc => _desc;

  String get tweetId => _tweetId;

  String get timeStamp => _timeStamp;

  String get uid => _uid;

  List get images => _images;

  Subscribed.map(json) {
    this._package = json["package"];
    this._status = json["status"];
    this._program = json["program"];
    this._account = json["account_details"];
    this._price = json["price"];
    this._starting = json["start_time"];
    this._text = json["message"];
    this._tweetId = json["tweet_id"].toString();
    this._images = json["images"] ?? [];
    this._desc = json["desc"] ?? "";
    this._noOftweets = json["daily rate"].toString();
    this._timeStamp = json["Timestamp"].toString();
    this._uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package'] = this.package;
    data['status'] = this.status;
    data['account_details'] = this.account;
    data['uid'] = this.uid;
    data['program'] = this.program;
    data['start_time'] = this.startTime;
    data['Timestamp'] = this.timeStamp;
    data['message'] = this._text;
    data['images'] = this.images;
    return data;
  }
}
