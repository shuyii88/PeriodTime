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
  String? imageUrl;

  int? cycleLength;
  int? periodLength;
  DateTime? lastPeriodDate;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      newImageFile = File(picked.path);
    }
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    usernameController.text = data['username'] ?? '';
    phoneController.text = data['phone'] ?? '';
    emailController.text = data['email'] ?? '';
    gender = data['gender'];
    dob = data['dob'] != null ? DateTime.parse(data['dob']) : null;
    imagePath = data['imageUrl'];
  }

  Future<void> saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Upload the image to Firebase Storage if there's a new one
    if (newImageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/$uid.jpg');
      await storageRef.putFile(newImageFile!);
      imageUrl = await storageRef.getDownloadURL();
    }



    final updates = {
      'username': usernameController.text.trim(),
      'phone': phoneController.text.trim(),
      'gender': gender,
      'dob': dob?.toIso8601String(),
    'imageUrl': imageUrl,
    };

    await FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .update(updates);
  }

  Future<void> loadPeriodData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('PeriodData')
            .doc(uid)
            .get();
    if (!doc.exists) return;

    final data = doc.data()!;
    cycleLength = data['cycleLength'] ?? 0;
    periodLength = data['periodLength'] ?? 0;
    lastPeriodDate =
        data['lastPeriodDate'] != null ? DateTime.parse(data['lastPeriodDate']) : null;
    ;
  }


  Future<void> savePeriodData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('PeriodData').doc(uid);
    final doc = await docRef.get();

    final data = {
      'cycleLength': cycleLength ?? 0,
      'periodLength': periodLength ?? 0,
      'lastPeriodDate': lastPeriodDate?.toIso8601String() ?? '',
    };

    if (!doc.exists) {
      await docRef.set(data); // Creates document if it doesn't exist
    } else {
      await docRef.update(data); // Updates existing document
    }
  }

  Future<void> clearUserData() async {
    usernameController.text = '';
    phoneController.text = '';
    emailController.text = '';
    gender = null;
    dob = null;
    imagePath = null;
    imageUrl = null;
    cycleLength = null;
    periodLength = null;
    lastPeriodDate = null;
  }
}
