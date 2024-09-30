import 'package:flutter/material.dart';
import 'package:front_travelbuddy/screens/log_in_screen.dart';
import 'package:front_travelbuddy/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
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
                        child: Text('Log in',
                            style: TextStyle(fontSize: width * 0.0135 * temp, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Montserrat')),
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
                        child: Text('Sign up',
                            style: TextStyle(fontSize: width * 0.0135 * temp, color: Colors.white, fontWeight: FontWeight.w400, decoration: TextDecoration.none, fontFamily: 'Montserrat')),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class Iteration2WIdgetsResize extends StatelessWidget {
  const Iteration2WIdgetsResize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background/_4ed7e042-0cde-4836-bc0d-c155d0c50ba0.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var screenWidth = constraints.maxWidth;
                      var screenHeight = constraints.maxHeight;

                      var brushWidth = screenWidth * 0.35;
                      var brushHeight = screenHeight * 0.2;

                      var offsetX = screenWidth * 0.1;
                      var offsetY = screenHeight * 0.4;

                      return Stack(
                        children: [
                          Positioned(
                            right: offsetX,
                            bottom: offsetY,
                            child: Column(
                              children: [
                                Container(
                                  width: brushWidth,
                                  height: brushHeight,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/brush_strokes/orange_1.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Column(
                                    //mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: brushWidth * 0.02),
                                      Text(
                                        "The world is a beautiful place",
                                        style: TextStyle(fontSize: screenWidth * 0.019, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Sorts Mill Goudy'),
                                      ),
                                      Align(
                                        alignment: Alignment(0.55, 0),
                                        child: Text(
                                          "Let's learn about it",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.016,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: brushHeight * 0.5,
                                  width: brushWidth * 0.5,
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3.png'))),
                                  child: Align(
                                    alignment: Alignment(0.13, -0.1),
                                    child: TextButton(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen())),
                                      child: Text('Log in', style: TextStyle(fontSize: screenWidth * 0.014, color: Colors.white, decoration: TextDecoration.none)),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: brushHeight * 0.5,
                                  width: brushWidth * 0.5,
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3.png'))),
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment(0.13, -0.1),
                                      child: TextButton(
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                                        child: Text('Sign up', style: TextStyle(fontSize: screenWidth * 0.014, fontWeight: FontWeight.w100, color: Colors.white, decoration: TextDecoration.none)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}