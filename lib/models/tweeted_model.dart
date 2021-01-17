class TweetedResponse {
  int id;
  String username;
  String packageName;
  String program;
  String tweetText;
  int numberOfTweetsPerDay;
  int period;
  int noOfSentTweets;
  String createdAt;
  String scheduledAt;
  String accessToken;
  String accessTokenSecret;
  List<Images> images;

  TweetedResponse(
      {this.id,
        this.username,
        this.packageName,
        this.program,
        this.tweetText,
        this.numberOfTweetsPerDay,
        this.period,
        this.noOfSentTweets,
        this.createdAt,
        this.scheduledAt,
        this.accessToken,
        this.accessTokenSecret,
        this.images});

  TweetedResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    packageName = json['package_name'];
    program = json['program'];
    tweetText = json['tweet_text'];
    numberOfTweetsPerDay = json['number_of_tweets_per_day'];
    period = json['period'];
    noOfSentTweets = json['no_of_sent_tweets'];
    createdAt = json['created_at'];
    scheduledAt = json['scheduled_at'];
    accessToken = json['access_token'];
    accessTokenSecret = json['access_token_secret'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['package_name'] = this.packageName;
    data['program'] = this.program;
    data['tweet_text'] = this.tweetText;
    data['number_of_tweets_per_day'] = this.numberOfTweetsPerDay;
    data['period'] = this.period;
    data['no_of_sent_tweets'] = this.noOfSentTweets;
    data['created_at'] = this.createdAt;
    data['scheduled_at'] = this.scheduledAt;
    data['access_token'] = this.accessToken;
    data['access_token_secret'] = this.accessTokenSecret;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String image;

  Images({this.image});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
