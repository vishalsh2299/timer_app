import 'package:flutter/material.dart';
import 'package:timer_app/timer_app_method_channel.dart';

enum Status { pause, resume, stop }

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

class _TimerAppState extends State<TimerApp>
    with SingleTickerProviderStateMixin {
  final double _totalTime = 10.0;
  final _methodTimer = MethodChannelTimerApp();
  double? _value, _height = 0.0;
  Status _status = Status.stop;

  late AnimationController _controller;
  Animation? _sizeAnimation;

  @override
  void dispose() {
    super.dispose();
    _methodTimer.stopListener();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: _totalTime.toInt()));

    _controller.addListener(() {
      setState(() {});
    });

    _value = _totalTime;

    _methodTimer.timerListen(
      TimerListener(
        onSuccess: (dynamic event) {
          setState(() {
            _value = double.tryParse(event.toString()) ?? 0.0;

            if (event == "FINISHED") {
              // _isStarted = false;
              _status = Status.stop;
              _value = _totalTime;

              _methodTimer.pause();
              _controller.reset();

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
      backgroundColor: const Color.fromARGB(255, 242, 88, 88),
      body: Stack(
        children: [
          Container(
            height: _sizeAnimation == null
                ? MediaQuery.of(context).size.height
                : _sizeAnimation!.value,
            color: const Color.fromARGB(255, 61, 77, 95),
            alignment: Alignment.center,
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
                    switch (_status) {
                      case Status.stop:
                        _sizeAnimation = Tween<double>(
                                begin: MediaQuery.of(context).size.height,
                                end: 0.0)
                            .animate(_controller);
                        _controller.forward();

                        _methodTimer.start(_totalTime);
                        _height = _height == 0
                            ? MediaQuery.of(context).size.height
                            : 0;

                        _status = Status.pause;
                        break;

                      case Status.resume:
                        _methodTimer.resume();

                        _height = MediaQuery.of(context).size.height;
                        _controller.forward();

                        _status = Status.pause;
                        break;

                      case Status.pause:
                        _controller.stop();

                        _methodTimer.pause();
                        _status = Status.resume;

                        double percTimePassed =
                            (_totalTime - _value!) / _totalTime;

                        _height =
                            MediaQuery.of(context).size.height * percTimePassed;

                        break;
                      default:
                    }

                    setState(() {});
                  },
                  icon: Icon(
                    // !_isStarted ? Icons.restart_alt_outlined : Icons.pause,
                    _status == Status.stop || _status == Status.resume
                        ? Icons.play_arrow
                        : Icons.pause,
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
