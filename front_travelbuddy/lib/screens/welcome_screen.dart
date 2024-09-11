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

        if (windowRatio < 16 / 9) {
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
                constraints: BoxConstraints(maxHeight: height, maxWidth: width),
                child: Image.asset(
                  'assets/background/_4ed7e042-0cde-4836-bc0d-c155d0c50ba0.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 0.25 * height,
                right: 0.15 * width,
                child: Container(
                  width: 0.35 * width,
                  height: 0.2 * height,
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
                      Text(
                        "The world is a beautiful place",
                        style: TextStyle(fontSize: width * 0.019, fontWeight: FontWeight.w100, color: Colors.white, decoration: TextDecoration.none, fontFamily: 'Sorts Mill Goudy'),
                      ),
                      Align(
                        alignment: Alignment(0.55, 0),
                        child: Text(
                          "Let's learn about it",
                          style: TextStyle(fontSize: width * 0.015, color: Colors.white, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontFamily: 'Sorts Mill Goudy'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0.45 * height,
                right: 0.22 * width,
                child: Container(
                  height: 0.1 * height,
                  width: 0.2 * width,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3.png'))),
                  child: AspectRatio(
                    aspectRatio: windowRatio,
                    child: Align(
                      alignment: Alignment(0.11, 0),
                      child: TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen())),
                        child: Text('Log in', style: TextStyle(fontSize: width * 0.013, color: Colors.white, decoration: TextDecoration.none)),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0.55 * height,
                right: 0.22 * width,
                child: Container(
                  height: 0.1 * height,
                  width: 0.2 * width,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/brush_strokes/orange_3.png'))),
                  child: AspectRatio(
                    aspectRatio: windowRatio,
                    child: Align(
                      alignment: Alignment(0.11, 0),
                      child: TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                        child: Text('Sign up', style: TextStyle(fontSize: width * 0.013, color: Colors.white, decoration: TextDecoration.none)),
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
                                        child: Text('Sign up', style: TextStyle(fontSize: screenWidth * 0.014, color: Colors.white, decoration: TextDecoration.none)),
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

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/background/_4ed7e042-0cde-4836-bc0d-c155d0c50ba0.jpg'), fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              width: 400,
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 10,
                    child: Container(
                      width: constraints.maxWidth * 0.5,
                      height: constraints.maxHeight * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/brush_strokes/orange_1.png',
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("The world is a beautifull place", style: TextStyle(fontSize: constraints.maxWidth * 0.02, color: Colors.white, decoration: TextDecoration.none)),
                          Text('Lets learn about it', style: TextStyle(fontSize: constraints.maxWidth * 0.02, color: Colors.white, decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen())),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/brush_strokes/orange_2.png'),
                        Text(
                          'Log in',
                          style: TextStyle(fontSize: 25, color: Colors.white, decoration: TextDecoration.none),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/brush_strokes/orange_2.png'),
                        Text(
                          'Sign up',
                          style: TextStyle(fontSize: 25, color: Colors.white, decoration: TextDecoration.none),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
