import 'package:cvak/okna/domu.dart';
import 'package:cvak/okna/nahrat.dart';
import 'package:cvak/okna/nastaveni.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

AppBar bar(context, {String nadpis = "Domů"}) => AppBar(
      title: Text(nadpis),
      actions: [
        PopupMenuButton<String>(
          itemBuilder: (c) => {'Nastavení', 'O Aplikaci'}
              .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onSelected: ((value) async {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            switch (value) {
              case "Nastavení":
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => const Nastaveni()));
                break;
              case "O Aplikaci":
                showAboutDialog(
                    context: context,
                    applicationName: "Cvak",
                    applicationLegalese:
                        "Copyright ©️ 2022 Matyáš Caras\nVydáno pod licencí GNU GPLv3",
                    applicationVersion: packageInfo.version,
                    children: [
                      TextButton(
                        child: const Text("Zdrojový kód"),
                        onPressed: () => launchUrl(
                            Uri.parse("https://git.mnau.xyz/hernik/cvak"),
                            mode: LaunchMode.externalApplication),
                      )
                    ]);
                break;
            }
          }),
        )
      ],
    );

Drawer drawer(int selected, BuildContext context) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text("Cvak")),
          ListTile(
            title: const Text("Domů"),
            leading: const Icon(Icons.home),
            selected: selected == 1,
            onTap: () => (selected == 1)
                ? Navigator.of(context).pop()
                : Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (c) => const DomovskaObrazovka())),
          ),
          ListTile(
            title: const Text("Nová jízdenka"),
            leading: const Icon(Icons.new_label),
            selected: selected == 2,
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: const Text("Nahrát jízdenky"),
            leading: const Icon(Icons.download),
            selected: selected == 3,
            onTap: () => (selected == 3)
                ? Navigator.of(context).pop()
                : Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => const NahratJizdenku())),
          ),
        ],
      ),
    );
