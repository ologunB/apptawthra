class TwitterKeys {
  String _token;
  String _tokenSecret;
  String _userId;
  String _screenName;

  String get token => _token;

  String get tokenSecret => _tokenSecret;

  String get userId => _userId;

  String get screenName => _screenName;

  TwitterKeys(this._token, this._tokenSecret, this._screenName, this._userId);

  TwitterKeys.map(json) {
    this._token = json["oauth_token"];
    this._tokenSecret = json["oauth_token_secret"];
    this._userId = json["user_id"];
    this._screenName = json["screen_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oauth_token'] = this.token;
    data['oauth_token_secret'] = this.tokenSecret;
    data['user_id'] = this.userId;
    data['screen_name'] = this.screenName;
    return data;
  }
}
