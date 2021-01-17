class TwitterKeys {
  String _token;
  String _token_secret;
  String _user_id;
  String _screen_name;

  String get token => _token;

  String get token_secret => _token_secret;

  String get user_id => _user_id;

  String get screen_name => _screen_name;

  TwitterKeys(this._token, this._token_secret, this._screen_name, this._user_id);

  TwitterKeys.map(json) {
    this._token = json["oauth_token"];
    this._token_secret = json["oauth_token_secret"];
    this._user_id = json["user_id"];
    this._screen_name = json["screen_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oauth_token'] = this.token;
    data['oauth_token_secret'] = this.token_secret;
    data['user_id'] = this.user_id;
    data['screen_name'] = this.screen_name;
    return data;
  }
}
