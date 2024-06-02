import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _currentUser = '';
  File? _profileImageFile;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _getCurrentUser();
    _getSavedImage();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _getSavedImage() async {
    final String? imagePath = _prefs.getString('profileImage');
    if (imagePath != null) {
      setState(() {
        _profileImageFile = File(imagePath);
      });
    }
  }

  Future<void> _getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser') ?? '';
    });
  }

  Future<void> _getImage() async {
    final PermissionStatus permissionStatus = await Permission.camera.request();
    if (permissionStatus == PermissionStatus.granted) {
      final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _profileImageFile = File(pickedFile.path);
        });
        _prefs.setString('profileImage', pickedFile.path);
      }
    } else {
      // Handle permission denied
    }
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('currentUser');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login as $_currentUser',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Text(
                  'Profile Picture',
                  style: GoogleFonts.poppins(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                IconButton(
                  icon: _profileImageFile != null
                      ? CircleAvatar(
                    radius: 100,
                    backgroundImage: FileImage(_profileImageFile!),
                  )
                      : Icon(Icons.camera_alt),
                  onPressed: _getImage,
                  iconSize: 40,
                  color: Colors.black87,
                  splashRadius: 25,
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'About This App',
              style: GoogleFonts.poppins(
                  fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ExpansionTile(
              title: Text('1. Home Explanation', style: GoogleFonts.poppins()),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'In the home section, there are drink categories, and after selecting a category, there are drink options according to the category you selected. You can use the search to find the drink you want. After selecting a drink, you can see the details such as ingredients, materials, and instructions for making the drink.',
                    style: GoogleFonts.poppins(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('2. Reservation Explanation',
                  style: GoogleFonts.poppins()),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'In this app, we provide online reservations to make it easier for customers. The reservation section includes fields for name, phone number, reservation date, and number of people.',
                    style: GoogleFonts.poppins(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Center(
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}