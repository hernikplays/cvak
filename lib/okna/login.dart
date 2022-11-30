import 'package:cvak/api/ceskedrahy.dart';
import 'package:flutter/material.dart';

class LoginStranka extends StatefulWidget {
  const LoginStranka({super.key});

  @override
  State<LoginStranka> createState() => _LoginStrankaState();
}

class _LoginStrankaState extends State<LoginStranka> {
  final _mailManager = TextEditingController();
  final _passManager = TextEditingController();
  var rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "E-mail"),
              controller: _mailManager,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: "Heslo"),
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
          ]),
        ),
      ),
    );
  }
}
