library my_prj.globals;

import 'package:localstore/localstore.dart';
import 'dart:async';

import 'Matches.dart';

bool initial = false;
List favMatch = [];
final db = Localstore.instance;
final favs = <String, Favouritess>{};
StreamSubscription<Map<String, dynamic>>? subscription;
bool isHeatPress = false;
