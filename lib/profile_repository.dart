// profile_repository.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository {
  // Private constructor
  ProfileRepository._();

  //Single, global instance
  static final ProfileRepository instance = ProfileRepository._();

  //Controllers and fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? gender;
  DateTime? dob;
  String? imagePath;
  File? newImageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      newImageFile = File(picked.path);
    }
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('User').doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    usernameController.text = data['username'] ?? '';
    phoneController.text    = data['phone'] ?? '';
    emailController.text    = data['email'] ?? '';
    gender                  = data['gender'];
    dob                     = data['dob'] != null ? DateTime.parse(data['dob']) : null;
    imagePath               = data['imagePath'];
  }

  Future<void> saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final updates = {
      'username': usernameController.text.trim(),
      'phone':    phoneController.text.trim(),
      'gender':   gender,
      'dob':      dob?.toIso8601String(),
      if (newImageFile != null) 'imagePath': newImageFile!.path,
    };

    await FirebaseFirestore.instance.collection('User').doc(uid).update(updates);
  }
}
