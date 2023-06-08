import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCkIoq-G28WGsdcBikXsq5HzE48MlIsSic",
          authDomain: "basic-services-1d374.firebaseapp.com",
          projectId: "basic-services-1d374",
          storageBucket: "basic-services-1d374.appspot.com",
          messagingSenderId: "529336874645",
          appId: "1:529336874645:web:67ea57ac5ee63d8512cd9c",
          measurementId: "G-Z7XL4THJLN"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool isMobile = false;
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portfoilo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        primarySwatch: Colors.purple,
        canvasColor: Colors.purple.shade50,
        fontFamily: 'Sans',
        useMaterial3: true,
      ),
      home: //Portfolio()
          LoginPage(),
    );
  }
}

//Register Page

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _UserNameCntr = TextEditingController();
  final _passwordCntr = TextEditingController();
  final _confirmPasswordCntr = TextEditingController();
  UserCredential? userCredential;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  Future<void> _addUser(context) async {
    String? _email = _UserNameCntr.text.trim();
    String? _pass = _passwordCntr.text.trim();
    String? _confirmPass = _confirmPasswordCntr.text.trim();

    if (_email.isEmpty || _pass.isEmpty || _confirmPass.isEmpty) {
      final snackBar = SnackBar(
        content: const Text('Fill All The Details!'),
        backgroundColor: (Colors.black12),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else if (_pass != _confirmPass) {
      final snackBar = SnackBar(
        content: const Text('! Password Not Matching'),
        backgroundColor: (Colors.black12),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Create new account
    else {
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _pass);
        print('User created');
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Portfolio()));
      } on FirebaseAuthException catch (e) {
        String _findError(e) {
          List<String> errors = [
            'weak-password',
            'invalid-email',
            'email-already-in-use'
          ];
          for (int i = 0; i < 3; i++) {
            if (e.toString().contains(errors[i]) == true) {
              return errors[i];
            }
          }
          return 'Error Occured';
        }

        final snackBar = SnackBar(
          content: Text(
            _findError(e),
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          backgroundColor: (Colors.black12),
          action: SnackBarAction(
            label: 'dismiss',
            onPressed: () {},
            backgroundColor: Colors.red,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  //Note on Registration
  Widget buildNote(field) {
    return Column(
      children: [
        Text(
          field,
          style: TextStyle(
              fontSize: 14.0, wordSpacing: 2.0, color: Colors.grey[800]),
        ),
        const SizedBox(
          height: 2.0,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'Assets/Images/day.jpg',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Center(
          child: Container(
            // decoration:
            //     BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
            width: isMobile ? 350 : 600,
            height: isMobile ? 500 : 700,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  FadeTransition(
                    opacity: _animation,
                    child: FlutterLogo(
                      size: isMobile ? 80.0 : 100.0,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20.0 : 40.0),

                  //User name
                  FadeTransition(
                      opacity: _animation,
                      child: TextField(
                          controller: _UserNameCntr,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'User Email',
                            labelStyle: TextStyle(color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ))),
                  SizedBox(height: isMobile ? 10.0 : 20.0),

                  //Password
                  FadeTransition(
                      opacity: _animation,
                      child: TextField(
                          controller: _passwordCntr,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ))),
                  SizedBox(height: isMobile ? 10.0 : 20.0),
                  //Confirm Password
                  FadeTransition(
                      opacity: _animation,
                      child: TextField(
                          controller: _confirmPasswordCntr,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ))),

                  SizedBox(height: isMobile ? 10.0 : 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNote('* Enter a valid Email'),
                      buildNote('* Password Must be Atleast 6-digits'),
                      buildNote(
                          '* Password Must Contain 0-9 , a-z , A-Z and Special Symbols'),
                    ],
                  ),
                  FadeTransition(
                    opacity: _animation,
                    child: ElevatedButton(
                      onPressed: () {
                        _addUser(context);
                      },
                      onHover: (flag) {},
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}

// Login Page

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _UserNameCntr = TextEditingController();
  final _passwordCntr = TextEditingController();

  UserCredential? userCredential;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  Future<void> _loginUser(context) async {
    String? _email = _UserNameCntr.text.trim();
    String? _pass = _passwordCntr.text.trim();

    if (_email.isEmpty || _pass.isEmpty) {
      final snackBar = SnackBar(
        content: const Text('Fill All The Details!'),
        backgroundColor: (Colors.black12),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Create new account
    else {
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _pass);
        if (userCredential!.user != null) {
          print('User Logged in');
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Portfolio()));
        }
      } catch (e) {
        String _findError(e) {
          List<String> errors = [
            'wrong-password',
            'invalid-email',
            'user-not-found',
          ];
          for (int i = 0; i < 3; i++) {
            if (e.toString().contains(errors[i]) == true) {
              return errors[i];
            }
          }
          return 'Error Occured';
        }

        final snackBar = SnackBar(
          content: Text(
            _findError(e),
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          backgroundColor: (Colors.black12),
          action: SnackBarAction(
            label: 'dismiss',
            onPressed: () {},
            backgroundColor: Colors.red,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  //Note on Registration
  Widget buildNote(field) {
    return Column(
      children: [
        Text(
          field,
          style: TextStyle(
              fontSize: 14.0, wordSpacing: 2.0, color: Colors.grey[800]),
        ),
        const SizedBox(
          height: 2.0,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'Assets/Images/day.jpg',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Center(
          child: Container(
            // decoration:
            //     BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
            width: isMobile ? 350 : 600,
            height: isMobile ? 500 : 700,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0),
            child: Column(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      FadeTransition(
                        opacity: _animation,
                        child: FlutterLogo(
                          size: isMobile ? 80.0 : 100.0,
                        ),
                      ),
                      SizedBox(height: isMobile ? 20.0 : 40.0),

                      //User name
                      FadeTransition(
                          opacity: _animation,
                          child: TextField(
                              controller: _UserNameCntr,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'User Email',
                                labelStyle: TextStyle(color: Colors.black87),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                              ))),
                      SizedBox(height: isMobile ? 10.0 : 20.0),

                      //Password
                      FadeTransition(
                          opacity: _animation,
                          child: TextField(
                              controller: _passwordCntr,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                              ))),
                      SizedBox(height: isMobile ? 10.0 : 20.0),
                      //Confirm Password

                      SizedBox(height: isMobile ? 10.0 : 20.0),

                      FadeTransition(
                        opacity: _animation,
                        child: ElevatedButton(
                          onPressed: () {
                            _loginUser(context);
                          },
                          onHover: (flag) {},
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          'New User? Register',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// Portfolio or Homepage
class Portfolio extends StatelessWidget {
  var isMobile = false;
  final navItems = [
    Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: ElevatedButton(onPressed: () {}, child: const Text('Education')),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(onPressed: () {}, child: const Text('Skills')),
    ),
  ];
  Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    isMobile = MediaQuery.of(context).size.width > 700 ? false : true;
    return Container(
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Kashaf Khan'),
              actions: isMobile ? null : navItems),
          drawer: isMobile
              ? Drawer(
                  child: ListView(
                    children: navItems,
                  ),
                )
              : null,
          body: const About()
          /*
        child: Chip(
              side: BorderSide(color: Colors.purple),
              labelStyle: TextStyle(backgroundColor: Colors.amber),
              label: Center(
                child: Text('HelloWorld'),
              ))*/
          ),
    );
  }
}

const LatLng currentLocation = LatLng(25.1193, 55.3773);

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  bool alreadyProfileSet = false;
  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No Image has is selected');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        var f = await image.readAsBytes();
        print('Image Picked ${image}');
        // log("Image Picked" as num);
        setState(() {
          webImage = f;
          _pickedImage = File('a');
          alreadyProfileSet = true;
        });
      } else {
        print('No Image has is selected');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: _pickedImage == null
              ? const CircleAvatar()
              : Container(
                  width: 300,
                  height: 300,
                  /*
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.green, Colors.cyan],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft)),
                          */
                  child:
                      ProfileWidget(imagePath: webImage, onClicked: _pickImage)
                  // ClipOval(
                  //   child: Image.memory(
                  //     webImage,
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  ),
        ),
        if (!alreadyProfileSet)
          ElevatedButton(
              onPressed: _pickImage, child: const Text("Select Image"))
      ],
    );

    //GoogleMap(
    //     initialCameraPosition: CameraPosition(target: currentLocation));
  }
}

class ProfileWidget extends StatefulWidget {
  final imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    // final image = Image.memory(widget.imagePath);
    final imageProvider = MemoryImage(widget.imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: imageProvider,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: widget.onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 4,
        child: buildCircle(
          color: Colors.lightBlue,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
