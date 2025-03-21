import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StateMachineController? _controller;
  SMIInput<double>? _xInput;
  SMIInput<double>? _yInput;

  // Store the size of the animation widget
  Size _animationSize = Size.zero;

  @override
  void initState() {
    super.initState();
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'FaceTracking-StateMachine', // Replace with your State Machine name
    );

    if (controller != null) {
      setState(() {
        _controller = controller;
        artboard.addController(controller);

        _xInput = controller.findInput<double>('xPosition');
        _yInput = controller.findInput<double>('yPosition');
      });
    }
  }

  // Handle mouse movement
  void _updatePosition(Offset position) {
    if (_xInput != null && _yInput != null) {
      setState(() {
        // Convert screen coordinates to animation coordinates
        // You might need to adjust these calculations based on your needs
        _xInput!.value = position.dx / _animationSize.width;
        _yInput!.value = position.dy / _animationSize.height;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 175, 173, 173),
        title: Text('Rive Animations',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: MouseRegion(
          onHover: (event) {
            _updatePosition(event.localPosition);
          },
          child: SizedBox(
            width: 400,
            height: 400,
            child: LayoutBuilder(
              builder: (context, constraints) {
                _animationSize =
                    Size(constraints.maxWidth, constraints.maxHeight);
                return RiveAnimation.asset(
                  'assets/michifacetracker (1).riv',
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
