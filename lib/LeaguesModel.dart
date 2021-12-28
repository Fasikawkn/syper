class Games {
  double? timeRequest;
  String? capacityRequests;
  String? remainRequests;
  String? lastTimeYourKey;
  List<GamesLive>? gamesLive;

  Games(
      {this.timeRequest,
      this.capacityRequests,
      this.remainRequests,
      this.lastTimeYourKey,
      this.gamesLive});

  Games.fromJson(Map<String, dynamic> json) {
    timeRequest = json['time_request'];
    capacityRequests = json['capacity_requests'];
    remainRequests = json['remain_requests'];
    lastTimeYourKey = json['last_time_your_key'];
    if (json['games_live'] != null) {
      gamesLive = <GamesLive>[];
      json['games_live'].forEach((v) {
        gamesLive!.add(new GamesLive.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_request'] = this.timeRequest;
    data['capacity_requests'] = this.capacityRequests;
    data['remain_requests'] = this.remainRequests;
    data['last_time_your_key'] = this.lastTimeYourKey;
    if (this.gamesLive != null) {
      data['games_live'] = this.gamesLive!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GamesLive {
  String? gameId;
  String? time;
  String? timeStatus;
  League? league;
  Home? home;
  Home? away;
  String? timer;
  String? score;
  String? bet365Id;

  GamesLive(
      {this.gameId,
      this.time,
      this.timeStatus,
      this.league,
      this.home,
      this.away,
      this.timer,
      this.score,
      this.bet365Id});

  GamesLive.fromJson(Map<String, dynamic> json) {
    gameId = json['game_id'];
    time = json['time'];
    timeStatus = json['time_status'];
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
    away = json['away'] != null ? new Home.fromJson(json['away']) : null;
    timer = json['timer'];
    score = json['score'];
    bet365Id = json['bet365_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_id'] = this.gameId;
    data['time'] = this.time;
    data['time_status'] = this.timeStatus;
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.home != null) {
      data['home'] = this.home!.toJson();
    }
    if (this.away != null) {
      data['away'] = this.away!.toJson();
    }
    data['timer'] = this.timer;
    data['score'] = this.score;
    data['bet365_id'] = this.bet365Id;
    return data;
  }
}

class League {
  String? name;
  String? cc;
  String? id;

  League({this.name, this.cc, this.id});

  League.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cc = json['cc'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cc'] = this.cc;
    data['id'] = this.id;
    return data;
  }
}

class Home {
  String? name;
  String? id;
  String? imageId;
  String? cc;

  Home({this.name, this.id, this.imageId, this.cc});

  Home.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    imageId = json['image_id'];
    cc = json['cc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['image_id'] = this.imageId;
    data['cc'] = this.cc;
    return data;
  }
}
