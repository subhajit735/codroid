import 'dart:io';

import 'package:codroid/constants/colors.dart';
import 'package:codroid/mobile/login_signup_welcome/Screens/Signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../m_courses_screen/m_courses_screen.dart';
import '../m_forums_screen/m_forum_screen.dart';
import '../m_ide_screen/m_ide_screen.dart';
import '../m_main_screen/m_main_screen.dart';
import '../m_practice_screen/m_practicescreen.dart';

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({Key? key}) : super(key: key);

  @override
  _MobileHomeScreenState createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  File? imgfile;
  String? _imagepath;

  @override
  Future getimage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // final imagepermanent = File(image.path);
      // setState(() {
      //   this._image = imagepermanent;
      // });
      setState(() {
        saveimage(image.path.toString());
        imgfile = File(image.path);
      });
    } on PlatformException catch (e) {
      print("failed to pick image : $e");
    }
  }

  void saveimage(path) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("profileimage", path);
    loadprofileimage();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadprofileimage();
  }

  void loadprofileimage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = sp.getString("profileimage");
    });
    // sp.setString("profileimage", path);
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [
    MobileMainScreen(),
    MobileCoursesScreen(),
    MobilePracticeScreen(),
    MobileForumsScreen(),
    MobileIdeScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Codroid"),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      ),

      //drawer
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        getimage();
                        saveimage(imgfile!.path);
                      },
                      child: _imagepath != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(File(_imagepath!)),
                            )
                          : const CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.add),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  const Text(
                    "Hello , Abhishek",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const Text(
                    "abhishek@gmail.com",
                    style: TextStyle(
                        fontSize: 13,
                        // fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ),
          ),
          //DrawerHeader
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Courses'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync_problem),
            title: const Text('Practice Problems'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Discussion'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text('Video Courses'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.pages),
            title: const Text('SDE Sheets'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Accounts'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
      //body

      body: _pages[_currentIndex],

      //bottom navigation bar
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.yellow,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        ),
        child: BottomNavigationBar(
          selectedItemColor: Color.fromARGB(255, 255, 0, 251),
          unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sync_problem),
              label: 'Problems',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Forums',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          elevation: 30,
        ),
      ),
    );
  }
}
