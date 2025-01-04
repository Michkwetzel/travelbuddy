import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front_travelbuddy/screens/log_in_screen.dart';
import 'package:front_travelbuddy/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      LayoutBuilder(
        builder: (context, constraints) {
          double width;
          double height;
          double windowRatio = constraints.maxWidth / constraints.maxHeight;
          double temp = 0.9;

          if (windowRatio <= (1791 / 993)) {
            height = constraints.maxHeight;
            width = constraints.maxHeight * 1791 / 993;
          } else {
            height = constraints.maxWidth * 993 / 1791;
            width = constraints.maxWidth;
          }

          if (constraints.maxWidth < 500) {
            return MobileWelcomeScreen(height: height, screenHeight: constraints.maxHeight, screenWidth: constraints.maxWidth, width: width, temp: temp, windowRatio: windowRatio);
          }
          return DesktopWelcomeScreen(height: height, width: width, temp: temp, windowRatio: windowRatio);
        },
      ),
      SizedBox(
        height: 100,
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0),
          title: Text(
            "Travel Buddy",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    ]);
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    super.key,
    required this.height,
    required this.screenHeight,
    required this.screenWidth,
    required this.width,
    required this.temp,
    required this.windowRatio,
  });

  final double height;
  final double width;
  final double temp;
  final double windowRatio;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CenteredScrollView(
        scrollDirection: Axis.vertical,
        child: CenteredScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(height: height, width: width),
            child: Image.asset(
              'assets/background/welcome_mountains.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.3,
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/brush_strokes/orange_1.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 10, top: screenWidth * 0.05, bottom: screenWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    "The world is a beautiful place",
                    style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Montserrat'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Let\'s learn about it',
                        style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w300, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        width: screenWidth * 0.09,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: screenWidth * 0.35,
            height: screenHeight * 0.08,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3 copy.png'))),
            child: Align(
              alignment: Alignment(0.15, -screenWidth * 0.000),
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen())),
                child: Text('Log in', style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Montserrat')),
              ),
            ),
          ),
          Container(
            width: screenWidth * 0.35,
            height: screenHeight * 0.08,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3 copy.png'))),
            child: Align(
              alignment: Alignment(0.2, -screenWidth * 0.000),
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                child: Text('Sign up', style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.white, fontWeight: FontWeight.w400, decoration: TextDecoration.none, fontFamily: 'Montserrat')),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

class DesktopWelcomeScreen extends StatelessWidget {
  const DesktopWelcomeScreen({
    super.key,
    required this.height,
    required this.width,
    required this.temp,
    required this.windowRatio,
  });

  final double height;
  final double width;
  final double temp;
  final double windowRatio;

  @override
  Widget build(BuildContext context) {
    return CenteredScrollView(
      scrollDirection: Axis.vertical,
      child: CenteredScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(children: [
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: height, width: width),
            child: Image.asset(
              'assets/background/welcome_mountains.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 0.3 * height,
            right: 0.18 * width,
            child: Container(
              width: 0.37 * width * temp,
              height: 0.125 * height * temp,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/brush_strokes/orange_1.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Align(
                alignment: Alignment(0.25, -0.3),
                child: Text(
                  "The world is a beautiful place",
                  style: TextStyle(fontSize: width * 0.019 * temp, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.363 * height,
            right: 0.215 * width,
            child: Text(
              'Let\'s learn about it',
              style: TextStyle(fontSize: width * 0.014 * temp, fontWeight: FontWeight.w300, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Montserrat'),
            ),
          ),
          Positioned(
            top: 0.43 * height,
            right: 0.24 * width,
            child: Container(
              height: 0.1 * height * temp,
              width: 0.2 * width * temp,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3.png'))),
              child: AspectRatio(
                aspectRatio: windowRatio,
                child: Align(
                  alignment: Alignment(0.11, -0.15),
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen())),
                    child:
                        Text('Log in', style: TextStyle(fontSize: width * 0.0135 * temp, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Montserrat')),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.52 * height,
            right: 0.24 * width,
            child: Container(
              height: 0.1 * height * temp,
              width: 0.2 * width * temp,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3.png'))),
              child: AspectRatio(
                aspectRatio: windowRatio,
                child: Align(
                  alignment: Alignment(0.11, -0.15),
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                    child:
                        Text('Sign up', style: TextStyle(fontSize: width * 0.0135 * temp, color: Colors.white, fontWeight: FontWeight.w400, decoration: TextDecoration.none, fontFamily: 'Montserrat')),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class CenteredScrollView extends StatefulWidget {
  final Widget child;
  final Axis scrollDirection;

  const CenteredScrollView({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  _CenteredScrollViewState createState() => _CenteredScrollViewState();
}

class _CenteredScrollViewState extends State<CenteredScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _centerScroll() {
    if (!_scrollController.hasClients) return;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double center = maxScroll * 0.5;
    _scrollController.animateTo(
      center,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _centerScroll());
        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: widget.scrollDirection,
          child: widget.child,
        );
      },
    );
  }
}
