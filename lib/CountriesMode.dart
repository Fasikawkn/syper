import 'dart:convert';

List<Countries> countriesFromJson(String str) =>
    List<Countries>.from(json.decode(str).map((x) => Countries.fromJson(x)));

String countriesToJson(List<Countries> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Countries {
  // ignore: non_constant_identifier_names
  Countries({this.code, this.country, this.translation, this.Imageurl});

  String? code;
  String? country;
  String? translation;
  // ignore: non_constant_identifier_names
  String? Imageurl;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
        code: json["Code"],
        country: json["Country"],
        translation: json["Translation"],
        Imageurl: json["Imageurl"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Country": country,
        "Translation": translation,
        "Imageurl": Imageurl,
      };
}
