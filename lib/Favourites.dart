import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sportswipe/Matches.dart';
import 'global.dart' as globals;
import 'package:hexcolor/hexcolor.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  void initState() {
    globals.subscription =
        globals.db.collection('favmatches').stream.listen((event) {
      setState(() {
        final item = Favouritess.fromMap(event);
        globals.favs.putIfAbsent(item.id!, () => item);
      });
    });
    if (kIsWeb) globals.db.collection('favmatches').stream.asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    if (globals.subscription != null) globals.subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: HexColor("#004B1F"),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                height: size.height * 0.12,
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
                        SvgPicture.asset("assets/starIcon.svg"),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: globals.favs.length > 0
                      ? Container(
                          child: ListView.builder(
                              itemCount: globals.favs.keys.length,
                              itemBuilder: (ctx, index) {
                                final key = globals.favs.keys.elementAt(index);
                                final item = globals.favs[key]!;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/starIcon.svg"),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Match $index",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                          Text('${item.date}',
                                              style: TextStyle(
                                                  color: Colors.white))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: SizedBox(
                                            height: size.height * 0.2,
                                            child: Card(
                                              elevation: 5.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              color: Colors.white,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15.0),
                                                    child: SvgPicture.asset(
                                                      "assets/firstTeam.svg",
                                                      height: 50,
                                                    ),
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
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              '${item.team1}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                        SvgPicture.asset(
                                                            "assets/line.svg"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: SizedBox(
                                            height: size.height * 0.2,
                                            child: Card(
                                              elevation: 5.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              color: Colors.white,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15.0),
                                                    child: SvgPicture.asset(
                                                      "assets/firstTeam.svg",
                                                      height: 50,
                                                    ),
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
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              '${item.team2}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                        SvgPicture.asset(
                                                            "assets/line.svg"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      : Center(
                          child: Text(
                            "No Favourite Match ..!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ))
            ],
          ),
        ],
      ),
    );
  }
}
