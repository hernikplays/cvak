import 'package:cvak/okna/domu.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
    Copyright (C) 2022 Matyáš Caras

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var p = await SharedPreferences.getInstance();
  if (p.getString("dlpath") == null) {
    p.setString("dlpath", (await getApplicationDocumentsDirectory()).path);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cvak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DomovskaObrazovka(),
    );
  }
}
