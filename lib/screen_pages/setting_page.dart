import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? gender;
  DateTime? dob;
  String? imagePath;
  File? newImageFile;

  bool isLoading = true;
  //bool notificationsEnabled = true;
  final TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('User').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        usernameController.text = data['username'] ?? '';
        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
        gender = data['gender'] ?? '';
        dob = DateTime.tryParse(data['dob'] ?? '');
        imagePath = data['imagePath'];
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newImageFile = File(picked.path));
    }
  }

  Future<void> saveChanges() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    String? updatedImageUrl = imagePath;

    if (newImageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${uid}_${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await storageRef.putFile(newImageFile!);
      updatedImageUrl = await uploadTask.ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('User').doc(uid).update({
      'username': usernameController.text.trim(),
      'phone': phoneController.text.trim(),
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'imagePath': updatedImageUrl,
    });

    setState(() {
      imagePath = updatedImageUrl;
      newImageFile = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated")),
    );
  }

  Future<void> changePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: InputDecoration(labelText: "Current Password"),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final user = FirebaseAuth.instance.currentUser;
                final cred = EmailAuthProvider.credential(
                  email: user!.email!,
                  password: currentPasswordController.text,
                );
                await user.reauthenticateWithCredential(cred);
                await user.updatePassword(newPasswordController.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Password updated successfully")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update password: $e")),
                );
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> submitFeedback() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email;

    if (feedbackController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('feedback').add({
      'uid': uid,
      'email': email,
      'message': feedbackController.text.trim(),
      'timestamp': Timestamp.now(),
    });

    feedbackController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback submitted. Thank you!')),
    );
  }

  void deleteAccount() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("This will permanently delete your account."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                navigator.pop();
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  final uid = user?.uid;
                  if (uid != null) {
                    await FirebaseFirestore.instance.collection('User').doc(uid).delete();
                    await user!.delete();
                    navigator.pushReplacementNamed('/login');
                  }
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text("Error deleting account: $e")),
                  );
                }
              },
              child: Text("Delete Account"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text("Settings"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink[100],
        leading: Icon(Icons.settings, color: Colors.black),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: newImageFile != null
                    ? FileImage(newImageFile!)
                    : (imagePath != null
                    ? NetworkImage(imagePath!) as ImageProvider
                    : AssetImage('assets/images/placeholder.png')),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) => setState(() => gender = value),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date of Birth: ${dob != null ? dob!.toLocal().toString().split(' ')[0] : 'Not set'}",
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: dob ?? DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) setState(() => dob = pickedDate);
                  },
                  child: Text('Edit DOB'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text("Save Changes"),
            ),
            ElevatedButton(
              onPressed: changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: Text("Change Password"),
            ),
            Divider(height: 40),
            // SwitchListTile(
            //   title: Text("Enable Notifications"),
            //   value: notificationsEnabled,
            //   onChanged: (bool value) {
            //     setState(() {
            //       notificationsEnabled = value;
            //     });
            //   },
            // ),
            //SizedBox(height: 20),
            Text("Feedback", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text("Submit Feedback"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text("Logout"),
            ),
            ElevatedButton(
              onPressed: deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text("Delete Account"),
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
