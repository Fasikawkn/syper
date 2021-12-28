class H2HResults {
  List<H2h>? h2h;
  List<Home>? home;
  List<Home>? away;

  H2HResults({this.h2h, this.home, this.away});

  H2HResults.fromJson(Map<String, dynamic> json) {
    if (json['h2h'] != null) {
      h2h = <H2h>[];
      json['h2h'].forEach((v) {
        h2h!.add(new H2h.fromJson(v));
      });
    }
    if (json['home'] != null) {
      home = <Home>[];
      json['home'].forEach((v) {
        home!.add(new Home.fromJson(v));
      });
    }
    if (json['away'] != null) {
      away = <Home>[];
      json['away'].forEach((v) {
        away!.add(new Home.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.h2h != null) {
      data['h2h'] = this.h2h!.map((v) => v.toJson()).toList();
    }
    if (this.home != null) {
      data['home'] = this.home!.map((v) => v.toJson()).toList();
    }
    if (this.away != null) {
      data['away'] = this.away!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class H2h {
  String? id;
  String? sportId;
  League? league;
  Home? home;
  Home? away;
  String? time;
  String? ss;
  String? timeStatus;

  H2h(
      {this.id,
      this.sportId,
      this.league,
      this.home,
      this.away,
      this.time,
      this.ss,
      this.timeStatus});

  H2h.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sportId = json['sport_id'];
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
    home = json['home'] != null ? new Home.fromJson(json['home']) : null;
    away = json['away'] != null ? new Home.fromJson(json['away']) : null;
    time = json['time'];
    ss = json['ss'];
    timeStatus = json['time_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sport_id'] = this.sportId;
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.home != null) {
      data['home'] = this.home!.toJson();
    }
    if (this.away != null) {
      data['away'] = this.away!.toJson();
    }
    data['time'] = this.time;
    data['ss'] = this.ss;
    data['time_status'] = this.timeStatus;
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
