import 'package:cvak/helper/bar.dart';
import 'package:cvak/helper/manager.dart';
import 'package:cvak/helper/theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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

class DomovskaObrazovka extends StatefulWidget {
  const DomovskaObrazovka({super.key});

  @override
  State<DomovskaObrazovka> createState() => _DomovskaObrazovkaState();
}

class _DomovskaObrazovkaState extends State<DomovskaObrazovka> {
  var content = <Widget>[const CircularProgressIndicator()];
  @override
  void initState() {
    super.initState();
    nacistJizdenky();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar(context),
      drawer: drawer(1, context),
      body: Center(
        child: SizedBox(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Vaše jízdenky",
              textAlign: TextAlign.center,
              style: Vzhled.nadpis,
            ),
            const SizedBox(
              height: 15,
            ),
            ...content
          ]),
        ),
      ),
    );
  }

  void nacistJizdenky() async {
    // permissions
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    Map<Permission, PermissionStatus> status;
    if (androidInfo.version.sdkInt <= 32) {
      status = await [
        Permission.storage,
      ].request();
    } else {
      status = await [Permission.photos].request();
    }

    var allAccepted = true;
    status.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    if (!allAccepted) {
      showFlash(
          context: context,
          duration: const Duration(seconds: 5),
          builder: (context, controller) => Flash.dialog(
              controller: controller,
              backgroundColor: Vzhled.errorColor,
              child: const Text(
                  "Aplikace nedokáže bez oprávnění k úložišti pracovat!")));
      setState(() {
        content = [const Text("Chybí oprávnění!")];
      });
      return;
    }
    // permissions end

    var j = ManazerJizdenek.nahratJizdenky();
    if (j.isEmpty) {
      setState(() {
        content = [const Text("Žádné uložené jízdenky :(")];
      });
    } else {
      content = [];
      for (var jizdenka in j) {
        content.add(Column(
          children: [
            Text("${jizdenka.zeStanice} - ${jizdenka.doStanice}",
                style: Vzhled.nadpisJizdenka)
          ],
        ));
      }
      setState(() {});
    }
  }
}
