class Overallgenerated {
  int? success;
  Results? results;

  Overallgenerated({this.success, this.results});

  Overallgenerated.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    results =
        json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  Season? season;
  Overall? overall;
  Overall? home;
  Overall? away;

  Results({this.season, this.overall, this.home, this.away});

  Results.fromJson(Map<String, dynamic> json) {
    season =
        json['season'] != null ? new Season.fromJson(json['season']) : null;
    overall =
        json['overall'] != null ? new Overall.fromJson(json['overall']) : null;
    home = json['home'] != null ? new Overall.fromJson(json['home']) : null;
    away = json['away'] != null ? new Overall.fromJson(json['away']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.season != null) {
      data['season'] = this.season!.toJson();
    }
    if (this.overall != null) {
      data['overall'] = this.overall!.toJson();
    }
    if (this.home != null) {
      data['home'] = this.home!.toJson();
    }
    if (this.away != null) {
      data['away'] = this.away!.toJson();
    }
    return data;
  }
}

class Season {
  String? sportId;
  String? startTime;
  String? endTime;
  String? hasTopgoals;
  String? hasLeaguetable;
  String? hasLineups;
  String? name1;
  // Null? name31;
  String? name;

  Season(
      {this.sportId,
      this.startTime,
      this.endTime,
      this.hasTopgoals,
      this.hasLeaguetable,
      this.hasLineups,
      this.name1,
      this.name});

  Season.fromJson(Map<String, dynamic> json) {
    sportId = json['sport_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    hasTopgoals = json['has_topgoals'];
    hasLeaguetable = json['has_leaguetable'];
    hasLineups = json['has_lineups'];
    name1 = json['name_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sport_id'] = this.sportId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['has_topgoals'] = this.hasTopgoals;
    data['has_leaguetable'] = this.hasLeaguetable;
    data['has_lineups'] = this.hasLineups;
    data['name_1'] = this.name1;
    data['name'] = this.name;
    return data;
  }
}

class Overall {
  List<Tournaments>? tournaments;

  Overall({this.tournaments});

  Overall.fromJson(Map<String, dynamic> json) {
    if (json['tournaments'] != null) {
      tournaments = <Tournaments>[];
      json['tournaments'].forEach((v) {
        tournaments!.add(new Tournaments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tournaments != null) {
      data['tournaments'] = this.tournaments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tournaments {
  String? name;
  List<Rows>? rows;

  Tournaments({this.name, this.rows});

  Tournaments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  String? leaguetableId;
  String? pos;
  String? sortPos;
  String? change;
  String? win;
  String? draw;
  String? loss;
  String? goalsfor;
  String? goalsagainst;
  String? points;

  Team? team;

  Rows(
      {this.leaguetableId,
      this.pos,
      this.sortPos,
      this.change,
      this.win,
      this.draw,
      this.loss,
      this.goalsfor,
      this.goalsagainst,
      this.points,
      this.team});

  Rows.fromJson(Map<String, dynamic> json) {
    leaguetableId = json['leaguetable_id'];
    pos = json['pos'];
    sortPos = json['sort_pos'];
    change = json['change'];
    win = json['win'];
    draw = json['draw'];
    loss = json['loss'];
    goalsfor = json['goalsfor'];
    goalsagainst = json['goalsagainst'];
    points = json['points'];
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaguetable_id'] = this.leaguetableId;
    data['pos'] = this.pos;
    data['sort_pos'] = this.sortPos;
    data['change'] = this.change;
    data['win'] = this.win;
    data['draw'] = this.draw;
    data['loss'] = this.loss;
    data['goalsfor'] = this.goalsfor;
    data['goalsagainst'] = this.goalsagainst;
    data['points'] = this.points;

    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    return data;
  }
}

class Team {
  String? id;
  String? name;
  String? imageId;
  String? cc;

  Team({this.id, this.name, this.imageId, this.cc});

  Team.fromJson(Map<String, dynamic> json) {
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
