import 'dart:io';

import 'package:cvak/helper/bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Nastaveni extends StatefulWidget {
  const Nastaveni({super.key});

  @override
  State<Nastaveni> createState() => _NastaveniState();
}

class _NastaveniState extends State<Nastaveni> {
  @override
  void initState() {
    super.initState();
    nacistNastaveni();
  }

  var content = <Widget>[const CircularProgressIndicator()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar(context, nadpis: "Nastavení"),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: content,
          ),
        ),
      ),
    );
  }

  void nacistNastaveni() async {
    content = [];
    SharedPreferences p = await SharedPreferences.getInstance();
    var dd = (p.getString("dlpath")!).split("/");
    content.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Složka s uloženými QR kódy jízdenek:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(dd[dd.length - 1]),
        const SizedBox(
          width: 10,
        ),
        TextButton(
            onPressed: () async {
              String? e = await FilePicker.platform.getDirectoryPath();
              if (e != null && e != "/") {
                p.setString("dlpath", e);
                nacistNastaveni();
              }
            },
            child: const Text("Změnit")),
        const SizedBox(
          width: 5,
        ),
        TextButton(
          onPressed: () async {
            p.setString(
                "dlpath", (await getApplicationDocumentsDirectory()).path);
            nacistNastaveni();
          },
          child: const Text("Výchozí"),
        ),
        const Divider(
          color: Colors.black,
          /*TODO: dark theme */
          height: 4,
        )
      ],
    ));
    setState(() {});
  }
}
