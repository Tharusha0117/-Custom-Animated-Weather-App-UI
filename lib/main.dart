import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weatherly',
      debugShowCheckedModeBanner: false,
      home: const WeatherHome(),
    );
  }
}

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  String currentWeather = 'sunny';

  void _toggleWeather() {
    setState(() {
      currentWeather = currentWeather == 'sunny'
          ? 'rainy'
          : currentWeather == 'rainy'
          ? 'cloudy'
          : 'sunny';
    });
  }

  List<Color> _getGradientColors() {
    switch (currentWeather) {
      case 'rainy':
        return [Colors.blueGrey.shade900, Colors.blue.shade500];
      case 'cloudy':
        return [Colors.grey.shade700, Colors.grey.shade500];
      case 'sunny':
      default:
        return [Colors.orange.shade200, Colors.deepOrangeAccent.shade700];
    }
  }

  Widget _buildParallaxEffect() {
    switch (currentWeather) {
      case 'cloudy':
        return Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return Icon(Icons.cloud, size: 100, color: Colors.white70)
                  .animate(onPlay: (controller) => controller.repeat())
                  .moveX(
                  begin: -20.0 * (index + 1),
                  end: 20.0 * (index + 1),
                  duration: (3 + index).seconds);
            }),
          ),
        );
      case 'rainy':
        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _RainPainter(),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSunRays() {
    if (currentWeather != 'sunny') return const SizedBox.shrink();
    return Positioned(
      top: 120,
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Colors.yellowAccent, Colors.transparent],
            stops: [0.2, 1.0],
          ),
        ),
      ).animate(onPlay: (controller) => controller.repeat())
          .scaleXY(begin: 1.0, end: 1.2, duration: 3.seconds)
          .fadeIn(duration: 1000.ms),
    );
  }

  Widget _buildMainIcon() {
    Icon icon;
    switch (currentWeather) {
      case 'rainy':
        icon = Icon(Icons.grain, size: 130, color: Colors.lightBlueAccent);
        break;
      case 'cloudy':
        icon = Icon(Icons.cloud, size: 130, color: Colors.white70);
        break;
      case 'sunny':
      default:
        icon = Icon(Icons.wb_sunny, size: 130, color: Colors.amberAccent);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: icon.color!.withOpacity(0.6),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: icon
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .rotate(begin: -0.05, end: 0.05, duration: 2.seconds)
          .fadeIn(duration: 800.ms),
    );
  }

  Widget _buildThermometer() {
    return Icon(Icons.thermostat, size: 60, color: Colors.redAccent)
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(begin: const Offset(1, 0.9), end: const Offset(1, 1.1))
        .fadeIn(duration: 500.ms);
  }

  Widget _glassCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: 1.seconds,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildParallaxEffect(),
            _buildSunRays(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMainIcon(),
                const SizedBox(height: 30),
                _buildThermometer(),
                const SizedBox(height: 50),
                _glassCard(
                  Column(
                    children: [
                      Text(
                        currentWeather.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black54,
                                blurRadius: 5,
                                offset: Offset(2, 2))
                          ],
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .fadeIn()
                          .shimmer(duration: 3.seconds),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap refresh to change weather',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ).animate().fadeIn(duration: 1.seconds)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleWeather,
        backgroundColor: Colors.white,
        child: const Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }
}

class _RainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);
    for (var i = 0; i < 200; i++) {
      final x = (i * 17) % size.width;
      final y = ((i * 19) % size.height) + (DateTime.now().millisecond / 10);
      canvas.drawLine(Offset(x.toDouble(), y), Offset(x.toDouble(), y + 10), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
