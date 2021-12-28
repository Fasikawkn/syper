import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Matches.dart';

class Matchess extends StatefulWidget {
  const Matchess({Key? key}) : super(key: key);

  @override
  _MatchessState createState() => _MatchessState();
}

class _MatchessState extends State<Matchess> {
  void _show(BuildContext ctx) {
    final List<ChartData> chartData = [
      ChartData('Team 1', double.parse("0"), Colors.yellow),
      ChartData('Team 2', double.parse("0"), Colors.green),
      ChartData('Draw', double.parse("0"), Colors.white),
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
              leagueName: "widget.matches[cardindex].league.name",
              date: "date",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ThirdColumn(
              team1: "team1!",
              team2: "team2!",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      new RotatedBox(
                          quarterTurns: 1,
                          child: Container(
                              height: 50,
                              width: 100,
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: new Text("team1Pos")),
                              ))),
                      new RotatedBox(
                          quarterTurns: 1,
                          child: Container(
                              height: 40,
                              width: 100,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: new Text(
                                  "team1Wins wins",
                                )),
                              ))),
                    ],
                  ),
                  Expanded(
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
                                    "0",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Played Since playedSince",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Row(
                    children: [
                      new RotatedBox(
                          quarterTurns: 1,
                          child: Container(
                              height: 40,
                              width: 100,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Center(child: new Text("team2Wins wins")),
                              ))),
                      new RotatedBox(
                          quarterTurns: 1,
                          child: Container(
                              height: 50,
                              width: 100,
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: new Text("team2Pos")),
                              ))),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            Center(
                child: Text(
              "totalDraws draw",
              style: TextStyle(color: Colors.white),
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: HexColor("#004B1F"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset("assets/menuIcon.svg"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset("assets/starIcon.svg"),
          )
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Container(
              height: size.height * 0.6,
              width: size.width,
              color: HexColor("#004B1F"),
            ),
            Container(
              height: size.height * 0.285,
              width: size.width,
              color: Colors.amber,
              child: Center(
                child: InkWell(
                    onTap: () {
                      _show(context);
                    },
                    child: Icon(Icons.update)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
