import 'package:cvak/okna/login.dart';
import 'package:flutter/material.dart';

class DomovskaObrazovka extends StatefulWidget {
  const DomovskaObrazovka({super.key});

  @override
  State<DomovskaObrazovka> createState() => _DomovskaObrazovkaState();
}

class _DomovskaObrazovkaState extends State<DomovskaObrazovka> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Column(children: [
            TextButton(
                onPressed: (() => Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => const LoginStranka()))),
                child: const Text("Přihlásit"))
          ]),
        ),
      ),
    );
  }
}
