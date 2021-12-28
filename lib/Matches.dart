// ignore: import_of_legacy_library_into_null_safe
import 'dart:convert';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:intl/intl.dart';
import 'package:localstore/localstore.dart';
import 'package:sportswipe/H2H_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'Favourites.dart';
import 'NotifficationManager.dart';
import 'global.dart' as globals;
import 'package:sportswipe/events_Model.dart';

class Matches extends StatefulWidget {
  final List matches;

  Matches({Key? key, required this.matches}) : super(key: key);

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> with TickerProviderStateMixin {
  NotificationManager notificationManager = NotificationManager();
  String? team1;
  String? team2;
  String? team1Id = '380996';
  String? team2Id;
  var date;
  Map<String, dynamic> carddata = {
    'away_manager': "N/A",
    'home_manager': "N/A",
    'stadium_data': "N/A",
    'referee': "N/A"
  };

  int cardindex = 0;
  Results result = Results();
  bool isLoading = false;
  String? team1Pos = "0";
  String? team2Pos = "0";
  String? team1Wins = "0";
  String? team2Wins = "0";
  String? totalDraws = "0";
  String? playedSince = "0";
  int? hour;
  int? min;
  int? sec;
  String? chart = "char";
  var totalMatches;

  Future<Results> getGameData(String gameId) async {
    final String url =
        'https://spoyer.ru/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=eventdata&game_id=$gameId';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));
    var checkextras = json.decode(response.body)['results'][0];
    setcarddata(checkextras);

    result = Results.fromJson(json.decode(response.body)['results'][0]);

    isLoading = false;

    return result;
  }

  setcarddata(data) {
    if (data['extra'] != null) {
      if (data['extra']['away_manager'] != null) {
        setState(() {
          carddata['away_manager'] = data['extra']['away_manager']['name'];
        });
      }
      if (data['extra']['home_manager'] != null) {
        setState(() {
          carddata['home_manager'] = data['extra']['home_manager']['name'];
        });
      }
      if (data['extra']['stadium_data'] != null) {
        setState(() {
          carddata['stadium_data'] = data['extra']['stadium_data']['name'];
        });
      }
      if (data['extra']['referee'] != null) {
        setState(() {
          carddata['referee'] = data['extra']['referee']['name'];
        });
      }
    }
  }

  timespantodate(timespan) {
    var format = DateFormat.y();
    return format.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timespan) * 1000));
  }

  currentMatchDateTime(timespan) {
    var format = DateFormat.yMd();
    return format.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timespan) * 1000));
  }

  favMatchTime(timestamp) {
    hour = DateTime.fromMicrosecondsSinceEpoch(timestamp).hour;
    min = DateTime.fromMicrosecondsSinceEpoch(timestamp).minute;
    sec = DateTime.fromMicrosecondsSinceEpoch(timestamp).second;
  }

  Future geth2h(String gameId) async {
    final String url =
        'https://spoyer.ru/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=h2h&game_id=$gameId';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    H2HResults res = H2HResults.fromJson(json.decode(response.body)['results']);
    var homeWins = 0;
    var awayWins = 0;
    var draw = 0;
    List dates = [];
    if (res.h2h!.length > 0) {
      for (var i = 0; i < res.h2h!.length; i++) {
        var arrobj = res.h2h![i];
        var home = res.h2h![0].home;
        dates.add(timespantodate(arrobj.time));
        var ss = arrobj.ss;
        if (arrobj.home!.id == home!.id) {
          if (int.parse(ss!.split("-")[0]) > int.parse(ss.split("-")[1])) {
            homeWins = homeWins + 1;
          } else if (int.parse(ss.split("-")[0]) <
              int.parse(ss.split("-")[1])) {
            awayWins = awayWins + 1;
          } else if (int.parse(ss.split("-")[0]) ==
              int.parse(ss.split("-")[1])) {
            draw = draw + 1;
          }
        } else {
          if (int.parse(ss!.split("-")[1]) > int.parse(ss.split("-")[0])) {
            homeWins = homeWins + 1;
          } else if (int.parse(ss.split("-")[1]) <
              int.parse(ss.split("-")[0])) {
            awayWins = awayWins + 1;
          } else if (int.parse(ss.split("-")[0]) ==
              int.parse(ss.split("-")[1])) {
            draw = draw + 1;
          }
        }
      }
      dates.sort();
      team1Wins = homeWins.toString().length == 0
          ? 'Not Availabe'
          : homeWins.toString();
      team2Wins = awayWins.toString().length == 0
          ? 'Not Availabe'
          : awayWins.toString();
      playedSince = dates.length > 0 ? dates[0].toString() : 'Not Available';
      totalDraws =
          draw.toString().length == 0 ? 'Not Availabe' : draw.toString();
      totalMatches = homeWins + awayWins + draw;
    }
    Loader.hide();
  }

  void _show(BuildContext ctx) {
    final List<ChartData> chartData = [
      ChartData('Team 1', double.parse(team1Wins!), Colors.yellow),
      ChartData('Team 2', double.parse(team2Wins!), Colors.green),
      ChartData('Draw', double.parse(totalDraws!), Colors.white),
    ];
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        color: HexColor("#004B1F"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SvgPicture.asset("assets/uparrow.svg"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            FirstColumn(),
            SecondColumn(
              leagueName: widget.matches[cardindex].league.name,
              date: date,
              tour: result.extra != null
                  ? result.extra!.round != null
                      ? result.extra!.round
                      : "0"
                  : "0",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ThirdColumn(
              team1: team1!,
              team2: team2!,
            ),
            Container(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: new RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                  height: 50,
                                  width: 100,
                                  color: Colors.green,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: new Text("$team1Pos")),
                                  ))),
                        ),
                        Expanded(
                          flex: 1,
                          child: new RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                  height: 40,
                                  width: 100,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: new Text("$team1Wins wins")),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            SfCircularChart(series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                  innerRadius: '85',
                                  dataSource: chartData,
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y)
                            ]),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    totalMatches != null
                                        ? " $totalMatches"
                                        : "0",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Played Since $playedSince",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: new RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                  height: 40,
                                  width: 100,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: new Text("$team2Wins wins")),
                                  ))),
                        ),
                        Expanded(
                          flex: 1,
                          child: new RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                  height: 50,
                                  width: 100,
                                  color: Colors.green,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: new Text("$team2Pos")),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
                child: Text(
              "$totalDraws draw",
              style: TextStyle(color: Colors.white),
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
                child: Text(
              "Facts about recent matches",
              style: TextStyle(color: Colors.white),
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Center(
                child: Container(
              constraints: BoxConstraints(maxWidth: 350),
              child: Text(
                "NOT AVAILABLE",
                style: TextStyle(color: Colors.white),
              ),
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            LastColumn(),
          ],
        ),
      ),
    );
  }

  Future getPositions(String leagueId) async {
    final String url =
        'https://spoyer.ru/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=tabledata&league=$leagueId';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var decodedata = json.decode(response.body)['results'];
      if (decodedata != null) {
        var rows = decodedata['overall']['tournaments'][0]['rows'];

        var team1Position =
            rows.where((element) => element['team']['id'] == team1Id).toList();

        team1Pos = team1Position[0]['pos'].toString();

        var team2Position =
            rows.where((element) => element['team']['id'] == team2Id).toList();

        team2Pos = team2Position[0]['pos'].toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = Localstore.instance.collection('favmatches').doc().id;
    CardController controller = CardController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset("assets/menuIcon.svg"),
                            InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => FavScreen())),
                                child: SvgPicture.asset("assets/starIcon.svg")),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: FutureBuilder<Results?>(
                        future: getGameData(widget.matches[cardindex].gameId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            team1 = snapshot.data!.home!.name.toString();
                            team2 = snapshot.data!.away!.name.toString();
                            date = currentMatchDateTime(snapshot.data!.time);

                            // team1Id = snapshot.data!.home!.id;
                            team2Id = snapshot.data!.away!.id;

                            return TinderSwapCard(
                              swipeUp: false,
                              swipeDown: false,
                              orientation: AmassOrientation.BOTTOM,
                              totalNum: widget.matches.length,
                              stackNum: 3,
                              swipeEdge: 4.0,
                              swipeCompleteCallback:
                                  (CardSwipeOrientation orientation,
                                      int index) {
                                if (orientation == CardSwipeOrientation.LEFT) {
                                  print("LEFTTTTTTTTTTTTTTTTTTTTTTTTTT");
                                  if (cardindex < widget.matches.length) {
                                    print("LEFTTTTTTTTTTTTTTTTTTTTTTTTTT");
                                    setState(() {
                                      isLoading = true;
                                    });
                                    cardindex = index;
                                  }
                                } else if (orientation ==
                                    CardSwipeOrientation.RIGHT) {
                                  print("Righttttttttttttttt 1");
                                  if (result.ss != null) {
                                    print("Righttttttttttttttt2");
                                    if (this.cardindex <
                                        widget.matches.length) {
                                      favMatchTime(int.parse(result.time!));
                                      print("Righttttttttttttttt3");
                                      setState(() {
                                        isLoading = true;
                                      });
                                      cardindex = cardindex + 1;
                                      final item = Favouritess(
                                          id: id,
                                          team1: team1,
                                          team2: team2,
                                          date: date.toString());

                                      item.save();
                                      globals.favs
                                          .putIfAbsent(item.id!, () => item);

                                      notificationManager.showNotificationDaily(
                                          id.toString(),
                                          "Sports Swipe",
                                          "Match About To Start",
                                          hour!,
                                          min!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Added To Favourite')));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Only Pre Games could be favoraite')));
                                  }
                                }
                              },
                              maxWidth: MediaQuery.of(context).size.width * 0.9,
                              maxHeight:
                                  MediaQuery.of(context).size.width * 0.9,
                              minWidth: MediaQuery.of(context).size.width * 0.8,
                              minHeight:
                                  MediaQuery.of(context).size.width * 0.8,
                              cardController: controller,
                              cardBuilder: (context, index) => Card(
                                color: HexColor("#004B1F"),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${date.toString()}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "15:50",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                        text: "Venue : ",
                                                        children: [
                                                          TextSpan(
                                                            text: isLoading ==
                                                                    false
                                                                ? "${carddata['stadium_data']}"
                                                                : "Loading",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ]),
                                                  ),
                                                ),
                                                Flexible(
                                                    child: RichText(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          text: "Judge : ",
                                                          children: [
                                                            TextSpan(
                                                              text: isLoading ==
                                                                      false
                                                                  ? "${carddata['referee']}"
                                                                  : "Loading",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Card(
                                                      elevation: 5.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      color: Colors.white,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          SvgPicture.asset(
                                                            "assets/firstTeam.svg",
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        isLoading ==
                                                                                false
                                                                            ? "${snapshot.data!.home!.name.toString()}"
                                                                            : "Loading",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    // : Text("Loading"),
                                                                    Expanded(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/swipeArrow.svg",
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/line.svg",
                                                                  width: 120,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/swipeArrow.svg",
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 6,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            isLoading == false
                                                                                ? "${carddata['home_manager']}"
                                                                                : "Loading",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Card(
                                                      elevation: 5.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      color: Colors.white,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          SvgPicture.asset(
                                                            "assets/firstTeam.svg",
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        isLoading ==
                                                                                false
                                                                            ? "${snapshot.data!.away!.name.toString()}"
                                                                            : "Loading",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    // : Text("Loading"),
                                                                    Expanded(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/swipeArrow.svg",
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/line.svg",
                                                                  width: 120,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/swipeArrow.svg",
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 6,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            isLoading == false
                                                                                ? "${carddata['away_manager']}"
                                                                                : "Loading",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                top: 50,
                                                left: 0.0,
                                                bottom: 60,
                                                child: SvgPicture.asset(
                                                  "assets/vs.svg",
                                                  height: 45,
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              swipeUpdateCallback: (DragUpdateDetails details,
                                  Alignment align) {},
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }),
                  )
                ],
              ),
              color: HexColor("#004B1F"),
            ),
          ),
          Expanded(
            child: Container(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                                onTap: cardindex < widget.matches.length
                                    ? () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        cardindex = cardindex + 1;
                                        // globals.isHeatPress = true;

                                        controller.triggerLeft();
                                      }
                                    : () {},
                                child: SvgPicture.asset("assets/cross.svg")),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: cardindex < widget.matches.length
                                  ? () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      // globals.isHeatPress = true;
                                      cardindex = cardindex + 1;
                                      controller.triggerLeft();
                                    }
                                  : () {},
                              child: Icon(
                                Icons.arrow_back,
                                color: HexColor("#004B1F"),
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 35,
                            ),
                            InkWell(
                                onTap: () async {
                                  Loader.show(context,
                                      isSafeAreaOverlay: false,
                                      isBottomBarOverlay: false,
                                      overlayColor: Colors.black26,
                                      progressIndicator:
                                          CircularProgressIndicator(
                                        backgroundColor: Colors.red,
                                      ),
                                      themeData: Theme.of(context)
                                          .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green)));
                                  await geth2h(
                                      widget.matches[cardindex].gameId);

                                  _show(context);
                                },
                                child:
                                    SvgPicture.asset("assets/swipeArrow.svg")),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "SWIPE",
                              style: TextStyle(
                                  fontSize: 18, color: HexColor("#004B1F")),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                                onTap: cardindex < widget.matches.length
                                    ? () {
                                        if (result.ss != null) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          // cardindex = cardindex + 1;
                                          controller.triggerRight();
                                          // final item = Favouritess(
                                          //     id: id,
                                          //     team1: result.home!.name!,
                                          //     team2: result.away!.name!,
                                          //     date: date.toString());
                                          // item.save();
                                          // favMatchTime(result.time);
                                          // globals.favs.putIfAbsent(
                                          //     item.id!, () => item);
                                          // favMatchTime(result.time);
                                          // notificationManager
                                          //     .showNotificationDaily(
                                          //         id,
                                          //         "Sports Swipe",
                                          //         "Match About To Start",
                                          //         hour!,
                                          //         min!);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //         content: Text(
                                          //             'Added To Favourite')));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Only Pre Games could be favoraite')));
                                        }
                                      }
                                    : () {},
                                child: SvgPicture.asset("assets/fav.svg")),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: cardindex < widget.matches.length
                                  ? () {
                                      if (result.ss != null) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        // cardindex = cardindex + 1;
                                        controller.triggerRight();
                                        //   final item = Favouritess(
                                        //       id: id,
                                        //       team1: result.home!.name!,
                                        //       team2: result.away!.name!,
                                        //       date: date.toString());
                                        //   item.save();
                                        //   globals.favs
                                        //       .putIfAbsent(item.id!, () => item);
                                        //   favMatchTime(result.time);
                                        //   notificationManager
                                        //       .showNotificationDaily(
                                        //           id,
                                        //           "Sports Swipe",
                                        //           "Match About To Start",
                                        //           hour!,
                                        //           min!);
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(SnackBar(
                                        //           content: Text(
                                        //               'Added To Favourite')));
                                        // } else {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(SnackBar(
                                        //           content: Text(
                                        //               'Only Pre Games could be favoraite')));
                                      }
                                    }
                                  : () {},
                              child: Icon(
                                Icons.arrow_forward,
                                color: HexColor("#004B1F"),
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              color: HexColor("#FFF131"),
            ),
          ),
        ],
      ),
    );
  }
}

class LastColumn extends StatelessWidget {
  const LastColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Betting",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: Colors.green,
              height: 50,
              width: 80,
              child: Center(
                child: Text(
                  "N/A",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              height: 50,
              width: 80,
              child: Center(
                child: Text(
                  "N/A",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              height: 50,
              width: 80,
              child: Center(
                child: Text(
                  "N/A",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ThirdColumn extends StatefulWidget {
  final String team1;
  final String team2;
  const ThirdColumn({Key? key, required this.team1, required this.team2})
      : super(key: key);

  @override
  _ThirdColumnState createState() => _ThirdColumnState();
}

class _ThirdColumnState extends State<ThirdColumn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "Team 1",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "${widget.team1}",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "Matches",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                "Noo",
                style: TextStyle(
                  color: HexColor("#004B1F"),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "Team 2",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "${widget.team2}",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SecondColumn extends StatefulWidget {
  final String? leagueName;
  final String? date;
  final String? tour;
  const SecondColumn({Key? key, this.date, this.leagueName, this.tour})
      : super(key: key);

  @override
  _SecondColumnState createState() => _SecondColumnState();
}

class _SecondColumnState extends State<SecondColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.green,
            ),
            child: Center(
              child: Text(
                "${widget.date}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
              ),
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.green,
            ),
            child: Center(
              child: Text(
                "${widget.leagueName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.green,
            ),
            child: Center(
              child: Text(
                "${widget.tour}",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class FirstColumn extends StatefulWidget {
  const FirstColumn({Key? key}) : super(key: key);

  @override
  _FirstColumnState createState() => _FirstColumnState();
}

class _FirstColumnState extends State<FirstColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                "Date",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w800),
              ),
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                "Tournament",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w800),
              ),
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                "Tour",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w800),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

/// Data Model
class Favouritess {
  final String? id;
  String? team1;
  String? team2;
  String? date;

  Favouritess({
    this.id,
    this.team1,
    this.team2,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team1': team1,
      'team2': team2,
      'date': date,
    };
  }

  factory Favouritess.fromMap(Map<String, dynamic> map) {
    return Favouritess(
      id: map['id'],
      team1: map['team1'],
      team2: map['team2'],
      date: map['date'],
    );
  }
}

extension ExtTodo on Favouritess {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('favmatches').doc(id).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('favmatches').doc(id).delete();
  }
}
