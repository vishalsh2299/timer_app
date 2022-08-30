import 'package:flutter/material.dart';
import 'package:timer_app/timer_app_method_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimerApp(),
    );
  }
}

class TimerApp extends StatefulWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  final double _totalTime = 10.0;
  final _methodTimer = MethodChannelTimerApp();

  double? _value, _height = 0.0;
  bool _isStarted = false;

  @override
  void dispose() {
    super.dispose();
    _methodTimer.stopListener();
  }

  @override
  void initState() {
    super.initState();
    _value = _totalTime;

    _methodTimer.timerListen(
      TimerListener(
        onSuccess: (dynamic event) {
          setState(() {
            _value = double.tryParse(event.toString()) ?? 0.0;

            if (event == "FINISHED") {
              _isStarted = false;
              _value = _totalTime;

              _methodTimer.stop();

              setState(() {});
            }
          });
        },
        onError: (String error) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEA8C8F),
      body: Stack(
        children: [
          AnimatedContainer(
            alignment: Alignment.center,
            height: _height ?? MediaQuery.of(context).size.height,
            color: const Color(0xff7393B3),
            duration: Duration(seconds: _totalTime.toInt()),
            curve: Curves.easeIn,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _value != null ? _value!.toStringAsFixed(0) : "0",
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(right: 55),
                  onPressed: () {
                    if (!_isStarted) {
                      _methodTimer.start(_totalTime);
                      _height =
                          _height == 0 ? MediaQuery.of(context).size.height : 0;
                    } else {
                      _methodTimer.stop();
                      _value = _totalTime;
                    }

                    setState(() {
                      _isStarted = !_isStarted;
                    });
                  },
                  icon: Icon(
                    !_isStarted ? Icons.restart_alt_outlined : Icons.pause,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
