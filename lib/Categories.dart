import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:sportswipe/CountriesMode.dart';
import 'package:sportswipe/LeaguesModel.dart';
import 'package:sportswipe/Matches.dart';
import 'package:sportswipe/PreMatchModel.dart';
import 'global.dart' as globals;
import 'Favourites.dart';
import 'GamesEndedModel.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool show = false;

  List leaguenames = [];
  List gamesRunning = [];

  bool isExpanded = false;
  Map<String, bool> expansionState = Map();
  int selected = 1; //attention
  int initialselected = -1;
  bool isLoading = false;
  List<GamesLive> gamesLive = [];
  List allmatches = [];
  // int currentIndex ;
  List<ExpandableController> controllerList = [];

  Future<List<Countries>> getCountries() async {
    final String url =
        'https://mocki.io/v1/9b15785d-1606-4a21-9206-267f71469d34';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    var decodedData = jsonDecode(response.body);

    List jsonResponse = decodedData;

    jsonResponse.forEach((element) {
      var expandedController = ExpandableController();
      controllerList.add(expandedController);
    });

    return jsonResponse.map((data) => new Countries.fromJson(data)).toList();
  }

  Future getLeagues(String cc) async {
    leaguenames = [];
    final String url =
        'https://spoyer.ru/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=livedata&sport=soccer';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body)['games_live'];

      if (l.length > 0) {
        gamesLive =
            List<GamesLive>.from(l.map((model) => GamesLive.fromJson(model)));

        for (var i = 0; i < gamesLive.length; i++) {
          if (gamesLive[i].league!.cc == cc) {
            leaguenames.add({
              'leagueid': gamesLive[i].league!.id!,
              'league': gamesLive[i].league!.name!,
              'gameid': gamesLive[i].gameId,
            });
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // dispose textEditingControllers to prevent memory leaks
    for (ExpandableController expandedController in controllerList) {
      expandedController.dispose();
    }
    Loader.hide();
  }

  Future<List<GamesLive>> allGamesLive() async {
    final String url =
        'https://spoyer.ru/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=livedata&sport=soccer';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body)['games_live'];

      if (l.isNotEmpty) {
        List<GamesLive> gamesprelist =
            List<GamesLive>.from(l.map((model) => GamesLive.fromJson(model)));

        Loader.hide();

        return gamesprelist;
      } else {
        return <GamesLive>[];
      }
    } else {
      return <GamesLive>[];
    }
  }

  getLiveMatch(leagueid) {
    List<GamesLive> matches = [];
    Iterable iterablematches = [];
    if (gamesLive.length > 0) {
      for (var i = 0; i < gamesLive.length; i++) {
        if (gamesLive[i].league!.id == leagueid) {
          matches.add(gamesLive[i]);
        }
        iterablematches = matches;
      }

      return iterablematches;
    }
  }

  Future getPrematch(leagueid) async {
    final String url =
        'https://spoyer.ru/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=predata&sport=soccer&league=$leagueid';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body)['games_pre'];

      if (l.isNotEmpty) {
        List<GamesPre> gamesprelist =
            List<GamesPre>.from(l.map((model) => GamesPre.fromJson(model)));

        return gamesprelist;
      } else {
        return <GamesPre>[];
      }
    } else {
      return <GamesPre>[];
    }
  }

  Future getGamesCompleted(leagueid) async {
    final String url =
        'https://spoyer.ru/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=enddata&sport=soccer&league=$leagueid';
    final client = new http.Client();
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body)['games_end'];
      if (l.isNotEmpty) {
        List<GamesEnd> gamesendlist =
            List<GamesEnd>.from(l.map((model) => GamesEnd.fromJson(model)));

        return gamesendlist;
      } else {
        return <GamesEnd>[];
      }
    } else {
      return <GamesEnd>[];
    }
  }

  Future getAllMatches(leagueid) async {
    List<GamesPre> prematches = await getPrematch(leagueid);
    List<GamesEnd> gamescompleted = await getGamesCompleted(leagueid);
    List<GamesLive> currentmatc = getLiveMatch(leagueid);
    allmatches =
        [currentmatc, prematches, gamescompleted].expand((x) => x).toList();

    Loader.hide();
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => Matches(
                  matches: allmatches,
                )));
  }

  @override
  void initState() {
    super.initState();
    getCountries();
    allGamesLive();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/menuIcon.svg"),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => FavScreen()));
                              },
                              child: SvgPicture.asset("assets/starIcon.svg")),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          Loader.show(context,
                              isSafeAreaOverlay: false,
                              isBottomBarOverlay: false,
                              overlayFromBottom: 80,
                              overlayColor: Colors.black26,
                              progressIndicator: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                              themeData: Theme.of(context)
                                  .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green)));
                          var allGames = await allGamesLive();
                          globals.isHeatPress = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      Matches(matches: allGames)));
                        },
                        child: SvgPicture.asset(
                          "assets/heatIcon.svg",
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                  color: HexColor("#004B1F"),
                ),
              ),
              Container(
                height: size.height * 0.31,
                width: size.width,
                color: HexColor("#30A836"),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
              height: size.height * 0.8,
              width: size.width,
              child: expandedPanel()),

          // expandedPanel(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget expandedPanel() {
    return FutureBuilder<List<Countries>>(
        future: getCountries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  return ExpandableNotifier(
                      child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ScrollOnExpand(
                          scrollOnExpand: true,
                          scrollOnCollapse: true,
                          child: ExpandablePanel(
                            controller: controllerList[index],
                            theme: const ExpandableThemeData(
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              hasIcon: false,
                              tapBodyToCollapse: true,
                            ),
                            header: InkWell(
                              onTap: isLoading == false
                                  ? () async {
                                      for (int i = 0;
                                          i < controllerList.length;
                                          i++) {
                                        if (i == index) {
                                          controllerList[i].expanded = true;

                                          setState(() {
                                            isLoading = true;
                                          });

                                          await getLeagues(snapshot
                                              .data![i].code!
                                              .toString());
                                        } else {
                                          controllerList[i].expanded = false;
                                        }
                                      }
                                    }
                                  : () {},
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          child: ClipOval(
                                            child: SvgPicture.network(
                                              "${snapshot.data![index].Imageurl}",
                                              fit: BoxFit.fill,
                                              height: 35,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data![index].country}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            collapsed: Container(),
                            expanded: isLoading == false
                                ? Container(
                                    height: 50,
                                    child: leaguenames.length == 0
                                        ? Center(child: Text("NO LEAGUES"))
                                        : ListView.builder(
                                            itemCount: leaguenames.length,
                                            itemBuilder: (ctx, index) {
                                              return ListTile(
                                                  onTap: () async {
                                                    Loader.show(context,
                                                        isSafeAreaOverlay:
                                                            false,
                                                        isBottomBarOverlay:
                                                            false,
                                                        overlayFromBottom: 80,
                                                        overlayColor:
                                                            Colors.black26,
                                                        progressIndicator:
                                                            CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                        themeData: Theme.of(
                                                                context)
                                                            .copyWith(
                                                                colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors
                                                                        .green)));
                                                    await getAllMatches(
                                                        leaguenames[index]
                                                            ['leagueid']);
                                                  },
                                                  title: Text(leaguenames[index]
                                                      ['league']));

                                              // : Text(leaguenames[0]['league']);
                                            }),
                                  )
                                : ListTile(title: Text("Loading Leagues ")),
                            builder: (_, collapsed, expanded) {
                              return Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              );
                              // expanded: Column(
                              //   children: [
                              //     Container(
                              //       height: 50,
                              //       width: MediaQuery.of(context).size.width,
                              //       color: Colors.red,
                              //       child: isLoading == false
                              //           ? leaguenames.length == 0
                              //               ? Text("No Leagues Found")
                              //               : Text(leaguenames[0]['league'])
                              //           : Container(
                              //               height: 50,
                              //               color: Colors.blue,
                              //               child: Text("Loading Leagues ")),
                              //     ),
                              //   ],
                              // ),
                              // builder: (_, collapsed, expanded) {
                              //   return Expandable(
                              //     collapsed: collapsed,
                              //     expanded: expanded,
                              //     theme: const ExpandableThemeData(
                              //         crossFadePoint: 0),
                              //   );
                            },
                          ),
                        ),
                      ],
                    ),
                  ));
                });
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Sorry Something Went Wrong',
              style: TextStyle(
                fontFamily: 'SfProLight',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ));
          }
          // By default, show a loading spinner.
          return Center(
            child: const CircularProgressIndicator(),
          );
        });
  }
}
