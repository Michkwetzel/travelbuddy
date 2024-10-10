import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front_travelbuddy/change_notifiers/spinner.dart';
import 'package:front_travelbuddy/screens/chatbot_screen.dart';
import 'package:front_travelbuddy/widgets/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:front_travelbuddy/services/auth_service.dart';

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
    final double center = maxScroll * 0.75;
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Colors.white,
        ),
        inAsyncCall: Provider.of<Spinner>(context).spinner,
        opacity: 0,
        blur: 0.2,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width;
            double height;
            double windowRatio = constraints.maxWidth / constraints.maxHeight;

            if (windowRatio < 1822 / 1030) {
              height = constraints.maxHeight;
              width = constraints.maxHeight * 1822 / 1030;
            } else {
              height = constraints.maxWidth * 1030 / 1822;
              width = constraints.maxWidth;
            }

            if (constraints.maxWidth < 500) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CenteredScrollView(
                    scrollDirection: Axis.vertical,
                    child: CenteredScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: width,
                        height: height,
                        child: Image.asset(
                          'assets/background/sign_up_camel.png',
                          fit: BoxFit.cover,
                          width: width,
                          height: height,
                        ),
                      ),
                    ),
                  ),
                  Center(child: RegisterWidgets())
                ],
              );
            } else {
              return CenteredScrollView(
                scrollDirection: Axis.vertical,
                child: CenteredScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: width,
                    height: height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/background/log_in_camel2.jpg',
                          fit: BoxFit.cover,
                          width: width,
                          height: height,
                        ),
                        RegisterWidgets()
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class RegisterWidgets extends StatefulWidget {
  const RegisterWidgets({super.key});

  @override
  State<RegisterWidgets> createState() => _RegisterWidgetsState();
}

class _RegisterWidgetsState extends State<RegisterWidgets> {
  String userEmail = '';
  String userPassword = '';
  String errorText = '';
  bool error = false;

  @override
  Widget build(BuildContext context) {
    Spinner spinner = Provider.of<Spinner>(context, listen: false);
    void createAccount() async {
      try {
        spinner.showSpinner();
        await Provider.of<AuthService>(context, listen: false).createUserWithEmailAndPassword(
          userEmail: userEmail,
          userPassword: userPassword,
          emailVerificationPopUp: () => emailVertificationDialog(context, 'A verification link has been sent to your email.\nPlease verify your account and log in.'),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Invalid';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email already in use';
        }
        if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email';
        }
        if (e.code == 'network-request-failed') {
          errorMessage = 'Connection lost';
        }
        if (e.code == 'weak-password') {
          errorMessage = 'Weak Password';
        }
        spinner.hideSpinner();
        setState(() {
          error = true;
          errorText = errorMessage;
        });
      } catch (e) {
        spinner.hideSpinner();
        print(e);
        setState(() {
          error = true;
        });
        print('Error: $e');
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
              "Learn about the world",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Bhavuka',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'By creating an account you get access to the free version of TravelBuddy',
            textAlign: TextAlign.center,
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
              "Email",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SizedBox(
          width: 500,
          height: 48,
          child: LogInTextfield(
              error: error,
              onChanged: (value) {
                userEmail = value;
              },
              onSubmit: () {
                setState(() {
                  error = false;
                });
                createAccount();
              }),
        ),
        if (error)
          Container(
            height: 25,
            width: 170,
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
              "Password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SizedBox(
            width: 500,
            height: 48,
            child: LogInTextfield(
              error: error,
              onChanged: (value) {
                userPassword = value;
              },
              onSubmit: () => createAccount(),
            )),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () => createAccount(),
          child: Text("Create Acount", style: TextStyle(fontSize: 13, fontFamily: 'Roboto', fontWeight: FontWeight.normal, color: Colors.black87)),
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

  const LogInTextfield({Key? key, required this.onChanged, required this.onSubmit, required this.error}) : super(key: key);

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
          style: TextStyle(fontSize: 17, fontFamily: 'Montserrat', fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: _isFocused || _hasText ? Colors.white.withOpacity(0.85) : Colors.white.withOpacity(0.40),
            focusColor: Colors.white.withOpacity(0.85),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(width: 0.1, color: widget.error ? Colors.red[300]! : Colors.white),
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