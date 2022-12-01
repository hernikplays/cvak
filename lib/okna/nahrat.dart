import 'package:cvak/helper/bar.dart';
import 'package:cvak/helper/manager.dart';
import 'package:cvak/helper/theme.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/ceskedrahy.dart';

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

class NahratJizdenku extends StatefulWidget {
  const NahratJizdenku({super.key});

  @override
  State<NahratJizdenku> createState() => _NahratJizdenkuState();
}

class _NahratJizdenkuState extends State<NahratJizdenku> {
  final supported = ["České dráhy"];
  var selected = "České dráhy";
  var content = [];

  final _mailManager = TextEditingController();
  final _passManager = TextEditingController();
  var rememberMe = false;
  @override
  void initState() {
    super.initState();
    content = [
      Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "E-mail"),
              controller: _mailManager,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\-_0-9\.]+@{0,1}[a-zA-Z\-_0-9\.]{0,}'))
              ],
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: "Heslo"),
              obscureText: true,
              controller: _passManager,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              Checkbox(
                value: rememberMe,
                onChanged: (v) {
                  rememberMe = v ?? false;
                },
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Zapamatovat si mě")
            ]),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () async {
                  var d = CeskeDrahy();
                  // otestovat přihlášení
                  try {
                    await d.logIn(_mailManager.text, _passManager.text);
                    for (var jizdenka in await d.ziskatJizdenky()) {
                      ManazerJizdenek.ulozitJizdenku(jizdenka);
                    }
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Jízdenky úspěšně uloženy."),
                      duration: Duration(seconds: 5),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Nepodařilo se přihlásit, zkontrolujte údaje a připojení."),
                      duration: Duration(seconds: 5),
                    ));
                  }
                },
                child: const Text("Přihlásit se"))
          ],
        ),
      ),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(3, context),
      appBar: bar(context, nadpis: "Nahrát jízdenku"),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Nahrát jízdenku z externího zdroje",
                textAlign: TextAlign.center,
                style: Vzhled.nadpis,
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton(
                value: selected,
                items: List.generate(
                    supported.length,
                    (i) => DropdownMenuItem(
                          value: supported[i],
                          child: Text(supported[i]),
                        )),
                onChanged: (v) {
                  if (v == null) return;
                  selected = v;
                  if (v == "České dráhý") {
                    content = [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _mailManager,
                            decoration:
                                const InputDecoration(hintText: "E-mail"),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'[a-zA-Z\-_0-9\.]+@{0,1}[a-zA-Z\-_0-9\.]{0,}'))
                            ],
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: _passManager,
                            decoration: const InputDecoration(
                              hintText: "Heslo",
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (v) {
                                rememberMe = v ?? false;
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("Zapamatovat si mě")
                          ]),
                          const SizedBox(height: 10),
                          TextButton(
                              onPressed: () async {
                                var d = CeskeDrahy();
                                // otestovat přihlášení
                                try {
                                  await d.logIn(
                                      _mailManager.text, _passManager.text);
                                  for (var jizdenka
                                      in await d.ziskatJizdenky()) {
                                    ManazerJizdenek.ulozitJizdenku(jizdenka);
                                  }
                                  if (!mounted) return;
                                  showFlash(
                                    duration: const Duration(seconds: 3),
                                    context: context,
                                    builder: ((context, controller) =>
                                        Flash.bar(
                                          controller: controller,
                                          backgroundColor: Vzhled.okColor,
                                          child: const Text(
                                              "Jízdenky úspěšně staženy"),
                                        )),
                                  );
                                } catch (e) {
                                  showFlash(
                                    duration: const Duration(seconds: 5),
                                    context: context,
                                    builder: ((context, controller) =>
                                        Flash.bar(
                                          controller: controller,
                                          backgroundColor: Vzhled.errorColor,
                                          child: const Text(
                                              "Chyba při stahování, zkontrolujte údaje a připojení"),
                                        )),
                                  );
                                }
                              },
                              child: const Text("Přihlásit se"))
                        ],
                      ),
                    ];
                  }
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ...content
            ],
          ),
        ),
      ),
    );
  }
}
