import 'dart:isolate';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isolate Example")),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                count();
              },
              child: const Text('Without Isolate'),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                final recivePort = ReceivePort();
                final isolate =
                    await Isolate.spawn(countInIsolate, recivePort.sendPort);
                recivePort.listen((message) {
                  debugPrint("Count value with tin the isolate: $message");
                  isolate.kill();
                });
              },
              child: const Text('With Isolate'),
            ),
          ],
        ),
      )),
    );
  }
}

//Home Class ended here

void count() {
  const int target = 4000000000;
  int count = 0;

  for (int i = 0; i < target; i++) {
    count++;
  }

  debugPrint('Counted up to $count');
}

void countInIsolate(SendPort sendPort) {
  const int target = 4000000000;
  int count = 0;

  for (int i = 0; i < target; i++) {
    count++;
  }
  sendPort.send(count);
}
