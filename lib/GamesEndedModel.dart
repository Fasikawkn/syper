class GamesEnded {
  double? timeRequest;
  String? capacityRequests;
  String? remainRequests;
  String? lastTimeYourKey;
  String? dateGames;
  List<GamesEnd>? gamesEnd;

  GamesEnded(
      {this.timeRequest,
      this.capacityRequests,
      this.remainRequests,
      this.lastTimeYourKey,
      this.dateGames,
      this.gamesEnd});

  GamesEnded.fromJson(Map<String, dynamic> json) {
    timeRequest = json['time_request'];
    capacityRequests = json['capacity_requests'];
    remainRequests = json['remain_requests'];
    lastTimeYourKey = json['last_time_your_key'];
    dateGames = json['date_games'];
    if (json['games_end'] != null) {
      gamesEnd = <GamesEnd>[];
      json['games_end'].forEach((v) {
        gamesEnd!.add(new GamesEnd.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_request'] = this.timeRequest;
    data['capacity_requests'] = this.capacityRequests;
    data['remain_requests'] = this.remainRequests;
    data['last_time_your_key'] = this.lastTimeYourKey;
    data['date_games'] = this.dateGames;
    if (this.gamesEnd != null) {
      data['games_end'] = this.gamesEnd!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GamesEnd {
  String? gameId;
  String? time;
  String? timeStatus;
  League? league;
  Home? home;
  Home? away;
  String? score;

  GamesEnd(
      {this.gameId,
      this.time,
      this.timeStatus,
      this.league,
      this.home,
      this.away,
      this.score});

  GamesEnd.fromJson(Map<String, dynamic> json) {
    gameId = json['game_id'];
    time = json['time'];
    timeStatus = json['time_status'];
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
    away = json['away'] != null ? new Home.fromJson(json['away']) : null;
    score = json['score'];
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
    data['score'] = this.score;
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
