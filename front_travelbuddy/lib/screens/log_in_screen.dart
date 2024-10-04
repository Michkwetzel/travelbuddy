import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/services/auth_service.dart';
import 'package:front_travelbuddy/widgets/widgets.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 35,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white.withOpacity(0.80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          onPressed: () => passwordResetDialog(
            context,
            (email) => Provider.of<AuthService>(context, listen: false).resetPassword(userEmail: email),
          ),
          label: Text("Forget Password?", style: TextStyle(fontSize: 15, fontFamily: 'Bhavuka', fontWeight: FontWeight.w600, color: Colors.black)),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double width;
        double height;
        double windowRatio = constraints.maxWidth / constraints.maxHeight;

        if (windowRatio < 1792 / 1024) {
          height = constraints.maxHeight;
          width = constraints.maxHeight * 1792 / 1024;
        } else {
          height = constraints.maxWidth * 1024 / 1792;
          width = constraints.maxWidth;
        }

        if (constraints.maxWidth < 600) {
          //Mobile display
          double scale = 1;
          if (constraints.maxWidth < 410) {
            scale = (410 - constraints.maxWidth) * 0.1;
          }

          print('mobile');
          return Stack(alignment: Alignment.center, fit: StackFit.loose, children: [
            CenteredScrollView(
              child: CenteredScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: height, width: width),
                  child: Image.asset(
                    'assets/background/log_in_ocean.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Center(child: LogInWidgets(scale: scale))
          ]);
        } else {
          //Desktop display
          return CenteredScrollView(
            child: CenteredScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack( 
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.expand(height: height, width: width),
                    child: Image.asset(
                      'assets/background/log_in_ocean.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  LogInWidgets()
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}

class LogInWidgets extends StatefulWidget {
  final double scale;
  LogInWidgets({this.scale = 1, super.key});

  @override
  State<LogInWidgets> createState() => _LogInWidgetsState();
}

class _LogInWidgetsState extends State<LogInWidgets> {
  String userEmail = '';
  String userPassword = '';
  String errorText = '';
  bool error = false;
  @override
  Widget build(BuildContext context) {
    void logIn() async {
      try {
        await Provider.of<AuthService>(context, listen: false).signInWithEmailAndPassword(
          userEmail: userEmail,
          userPassword: userPassword,
          emailVerificationPopUp: () => emailVertificationDialog(context, 'Another verification link has been sent to your email.\nPlease verify your account and log in.'),
          nextScreenCall: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Invalid';
        if (e.code == 'user-not-found') {
          errorMessage = "Wrong email";
        }
        if (e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS' || e.code == 'invalid-credential') {
          errorMessage = "Wrong password";
        }
        if (e.code == 'invalid-email') {
          errorMessage = "Invalid email";
        }
        if (e.code == 'network-request-failed') {
          errorMessage = "Connection lost";
        }
        setState(() {
          error = true;
          errorText = errorMessage;
        });
      } catch (e) {
        setState(() {
          error = true;
        });
        print('Error: $e');
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                opacity: 0.89,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                fit: BoxFit.fill,
                image: AssetImage('assets/brush_strokes/blue_4.png'),
              ),
            ),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                "Welcome back adventurer",
                style: TextStyle(
                  fontSize: 35 - widget.scale,
                  fontFamily: 'Bhavuka',
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 40,
          width: 70,
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 0.89,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              fit: BoxFit.fill,
              image: AssetImage('assets/brush_strokes/blue_2.png'),
            ),
          ),
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              "Email",
              style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SizedBox(
            width: 500,
            height: 48,
            child: LogInTextfield(
              onChanged: (value) {
                userEmail = value;
              },
              onSubmit: () => logIn(),
              error: error,
              errorText: errorText,
            )),
        if (error)
          Container(
            height: 25,
            width: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                opacity: 0.89,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                fit: BoxFit.fill,
                image: AssetImage('assets/brush_strokes/blue_2.png'),
              ),
            ),
            child: Center(
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red[300], fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        Container(
          height: 40,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 0.89,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              fit: BoxFit.fill,
              image: AssetImage('assets/brush_strokes/blue_2.png'),
            ),
          ),
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              "Password",
              style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SizedBox(
            width: 500,
            height: 48,
            child: LogInTextfield(
              error: error,
              errorText: errorText,
              onChanged: (value) {
                print(value);
                userPassword = value;
              },
              onSubmit: () {
                print(userPassword);
                setState(() {
                  error = false;
                });
                logIn();
              },
            )),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () => logIn(),
          child: Text("Log in", style: TextStyle(fontSize: 13, fontFamily: 'Roboto', fontWeight: FontWeight.normal, color: Colors.black87)),
        ),
        SizedBox(
          width: 20,
        ),
        LineBreak(colour: 'white'),
        GoogleSignInButton(
          onPressed: () async {
            await Provider.of<AuthService>(context, listen: false).signInWithGoogle(
              nextScreenCall: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())),
            );
          },
        )
      ],
    );
  }
}

class LogInTextfield extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback onSubmit;
  final bool error;
  final String errorText;

  const LogInTextfield({Key? key, required this.onChanged, required this.onSubmit, required this.error, required this.errorText}) : super(key: key);

  @override
  _LogInTextfield createState() => _LogInTextfield();
}

class _LogInTextfield extends State<LogInTextfield> {
  bool _isFocused = false;
  bool _hasText = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateHasText);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateHasText);
    _controller.dispose();
    super.dispose();
  }

  void _updateHasText() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            widget.onChanged(value);
            _updateHasText();
          },
          onSubmitted: (value) => widget.onSubmit(),
          style: TextStyle(fontSize: 17, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: _isFocused || _hasText ? Colors.white.withOpacity(0.85) : Colors.white.withOpacity(0.47),
            focusColor: Colors.white.withOpacity(0.85),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(width: 1.4, color: widget.error ? Colors.red[300]! : Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: widget.error ? Colors.red[300]! : Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: widget.error ? Colors.red[300]! : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

//passwordResetDialog(context, (email) => Provider.of<AuthService>(context, listen: false).resetPassword(userEmail: email))


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
    final double currentScroll = _scrollController.offset;
    final double center = maxScroll*0.4;
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

