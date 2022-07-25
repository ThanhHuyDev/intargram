import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intargram/screens/home_screen.dart';
import 'package:intargram/screens/profile_screen.dart';
import 'package:intargram/screens/upload_screen.dart';
import '../screens/save_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeItems = [
  const HomeScreen(),
  const SearchScreen(),
  const UploadPostScreen(),
  const FavoriteScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
