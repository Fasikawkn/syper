class EventsData {
  int? success;
  List<Results>? results;

  EventsData({this.success, this.results});

  EventsData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? id;
  String? sportId;
  String? time;
  String? timeStatus;
  League? league;
  Home? home;
  Home? away;
  String? ss;
  Timer? timer;
  Extra? extra;
  List<Events>? events;
  int? hasLineup;
  String? inplayCreatedAt;
  String? inplayUpdatedAt;
  String? confirmedAt;
  String? bet365Id;

  Results(
      {this.id,
      this.sportId,
      this.time,
      this.timeStatus,
      this.league,
      this.home,
      this.away,
      this.ss,
      this.timer,
      this.extra,
      this.events,
      this.hasLineup,
      this.inplayCreatedAt,
      this.inplayUpdatedAt,
      this.confirmedAt,
      this.bet365Id});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sportId = json['sport_id'];
    time = json['time'];
    timeStatus = json['time_status'];
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
    away = json['away'] != null ? new Home.fromJson(json['away']) : null;
    ss = json['ss'];
    timer = json['timer'] != null ? new Timer.fromJson(json['timer']) : null;
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    hasLineup = json['has_lineup'];
    inplayCreatedAt = json['inplay_created_at'];
    inplayUpdatedAt = json['inplay_updated_at'];
    confirmedAt = json['confirmed_at'];
    bet365Id = json['bet365_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sport_id'] = this.sportId;
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
    data['ss'] = this.ss;
    if (this.timer != null) {
      data['timer'] = this.timer!.toJson();
    }
    if (this.extra != null) {
      data['extra'] = this.extra!.toJson();
    }
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    data['has_lineup'] = this.hasLineup;
    data['inplay_created_at'] = this.inplayCreatedAt;
    data['inplay_updated_at'] = this.inplayUpdatedAt;
    data['confirmed_at'] = this.confirmedAt;
    data['bet365_id'] = this.bet365Id;
    return data;
  }
}

class League {
  String? id;
  String? name;
  String? cc;

  League({this.id, this.name, this.cc});

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cc = json['cc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cc'] = this.cc;
    return data;
  }
}

class Home {
  String? id;
  String? name;
  String? imageId;
  String? cc;

  Home({this.id, this.name, this.imageId, this.cc});

  Home.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageId = json['image_id'];
    cc = json['cc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_id'] = this.imageId;
    data['cc'] = this.cc;
    return data;
  }
}

class Timer {
  int? tm;
  int? ts;
  String? tt;
  int? ta;
  int? md;

  Timer({this.tm, this.ts, this.tt, this.ta, this.md});

  Timer.fromJson(Map<String, dynamic> json) {
    tm = json['tm'];
    ts = json['ts'];
    tt = json['tt'];
    ta = json['ta'];
    md = json['md'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tm'] = this.tm;
    data['ts'] = this.ts;
    data['tt'] = this.tt;
    data['ta'] = this.ta;
    data['md'] = this.md;
    return data;
  }
}

class Extra {
  // String? length;
  String? homePos;
  String? awayPos;
  League? awayManager;
  League? homeManager;
  String? numberofperiods;
  String? periodlength;
  League? referee;
  StadiumData? stadiumData;
  String? round;

  Extra(
      { //this.length,
      this.homePos,
      this.awayPos,
      this.awayManager,
      this.homeManager,
      this.numberofperiods,
      this.periodlength,
      this.referee,
      this.stadiumData,
      this.round});

  Extra.fromJson(Map<String, dynamic> json) {
    // length = json['length'].toString();
    homePos = json['home_pos'];
    awayPos = json['away_pos'];
    awayManager = json['away_manager'] != null
        ? new League.fromJson(json['away_manager'])
        : null;
    homeManager = json['home_manager'] != null
        ? new League.fromJson(json['home_manager'])
        : null;
    numberofperiods = json['numberofperiods'];
    periodlength = json['periodlength'];
    referee =
        json['referee'] != null ? new League.fromJson(json['referee']) : null;
    stadiumData = json['stadium_data'] != null
        ? new StadiumData.fromJson(json['stadium_data'])
        : null;
    round = json['round'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['length'] = this.length;
    data['home_pos'] = this.homePos;
    data['away_pos'] = this.awayPos;
    if (this.awayManager != null) {
      data['away_manager'] = this.awayManager!.toJson();
    }
    if (this.homeManager != null) {
      data['home_manager'] = this.homeManager!.toJson();
    }
    data['numberofperiods'] = this.numberofperiods;
    data['periodlength'] = this.periodlength;
    if (this.referee != null) {
      data['referee'] = this.referee!.toJson();
    }
    if (this.stadiumData != null) {
      data['stadium_data'] = this.stadiumData!.toJson();
    }
    data['round'] = this.round;
    return data;
  }
}

class StadiumData {
  String? id;
  String? name;
  String? city;
  String? country;
  String? capacity;
  String? googlecoords;

  StadiumData(
      {this.id,
      this.name,
      this.city,
      this.country,
      this.capacity,
      this.googlecoords});

  StadiumData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    country = json['country'];
    capacity = json['capacity'];
    googlecoords = json['googlecoords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city'] = this.city;
    data['country'] = this.country;
    data['capacity'] = this.capacity;
    data['googlecoords'] = this.googlecoords;
    return data;
  }
}

class Events {
  String? id;
  String? text;

  Events({this.id, this.text});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}
