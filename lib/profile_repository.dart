import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfileRepository {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? gender;
  DateTime? dob;
  String? imagePath;
  File? newImageFile;

  /// Loads the current user’s profile data from Firestore.
  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('User').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      usernameController.text = data['username'] ?? '';
      phoneController.text = data['phone'] ?? '';
      emailController.text = data['email'] ?? '';
      gender = data['gender'] ?? '';
      dob = DateTime.tryParse(data['dob'] ?? '');
      imagePath = data['imagePath'];

    }
  }

  /// Saves the profile. If [newImageFile] is non-null, uploads it and sets `imagePath` to its URL.
  Future<void> saveProfile({
    required String username,
    required String phone,
    required String email,
    String? gender,
    DateTime? dob,
    String? existingImagePath,
    File? newImageFile,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('User').doc(uid).update({
      'username': usernameController.text.trim(),
      'phone': phoneController.text.trim(),
      'gender': gender,
      'dob': dob?.toIso8601String(),
      if (newImageFile != null) 'imagePath': newImageFile.path,
    });
  }
}

