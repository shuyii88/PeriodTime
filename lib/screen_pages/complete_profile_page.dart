import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedGender;
  DateTime? selectedDOB;
  File? imageFile;
  bool isSaving = false;

  bool validateInputs() {
    final name = usernameController.text.trim();
    final phone = phoneController.text.trim();
    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    final phoneRegex = RegExp(r"^\d{8,11}$");

    if (!nameRegex.hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name must contain only letters.")),
      );
      return false;
    }

    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number must be 8–11 digits.")),
      );
      return false;
    }

    if (selectedGender == null || selectedDOB == null || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields.")),
      );
      return false;
    }

    return true;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> saveProfile() async {
    if (!validateInputs()) return;

    setState(() => isSaving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final imagePath = imageFile!.path;

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('user_images/${uid}_${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(imageFile!);

      // Wait for the upload to complete and get the download URL
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Save user information in Firestore
      await FirebaseFirestore.instance.collection('User').doc(uid).set({
        'username': usernameController.text.trim(),
        'phone': phoneController.text.trim(),
        'gender': selectedGender,
        'dob': selectedDOB!.toIso8601String(),
        'imagePath': imageUrl,  // Store the download URL of the image
        'email': FirebaseAuth.instance.currentUser!.email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile completed!")),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Complete Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                  backgroundColor: Colors.white,
                  child: imageFile == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[700])
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            RadioListTile<String>(
              title: Text("Female"),
              value: "Female",
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            RadioListTile<String>(
              title: Text("Male"),
              value: "Male",
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            SizedBox(height: 10),
            Text("Date of Birth: ${selectedDOB != null ? selectedDOB!.toLocal().toString().split(' ')[0] : 'Not selected'}"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) setState(() => selectedDOB = pickedDate);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text('Select DOB'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaving ? null : saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text(isSaving ? 'Saving...' : 'Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
