import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverAppRegistration extends StatefulWidget {
@override
_DriverAppRegistrationState createState() => _DriverAppRegistrationState();
}

class _DriverAppRegistrationState extends State<DriverAppRegistration> {
final _formKey = GlobalKey<FormState>();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();

bool isOnline = false; // By default, the driver starts offline

Future<void> sendLiveLocation() async {
final String serverUrl = 'https://afrounited-admin-1.onrender.com/api/driver/update';

try {
print('Transmitting signal to HQ...');

final response = await http.post(
Uri.parse(serverUrl),
headers: {'Content-Type': 'application/json'},
body: jsonEncode({
'driver_id': 'DRV-001',
'driver_name': 'Alpha Diallo',
'location': 'Kagbelen, Guinea',
'status': 'online'
}),
);

if (response.statusCode == 200) {
print('✅ Success: Dashboard received the signal!');
print('Server Response: ${response.body}');
} else {
print('❌ Error: Dashboard rejected the signal.');
}
} catch (e) {
print('❌ Connection failed: $e');
}
}


Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Color(0xFFF4F7F4),
appBar: AppBar(
backgroundColor: Color(0xFF2E5A27),
leading: IconButton(
icon: Icon(Icons.arrow_back, color: Colors.white),
onPressed: () {},
),
title: Text(
'Créer un Compte Afrounited',
style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
),
centerTitle: true,
),
body: SingleChildScrollView(
padding: EdgeInsets.all(20.0),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Rejoignez notre réseau',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Color(0xFF2E5A27),
),
),
SizedBox(height: 4),
Text(
'Choisissez votre profil et commencez à travailler ou commander.',
style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
),
SizedBox(height: 20),

// Profile Type Selection Row
Row(
children: [
Expanded(
child: Container(
padding: EdgeInsets.symmetric(vertical: 12),
decoration: BoxDecoration(
color: Colors.grey.shade200,
borderRadius: BorderRadius.circular(8),
),
child: Text(
'Rider',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.black54),
),
),
),
SizedBox(width: 10),
Expanded(
child: Container(
padding: EdgeInsets.symmetric(vertical: 12),
decoration: BoxDecoration(
color: Color(0xFF2E5A27),
borderRadius: BorderRadius.circular(8),
),
child: Text(
'Driver',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
),
),
),
SizedBox(width: 10),
Expanded(
child: Container(
padding: EdgeInsets.symmetric(vertical: 12),
decoration: BoxDecoration(
color: Colors.grey.shade200,
borderRadius: BorderRadius.circular(8),
),
child: Text(
'Restaurant',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.black54),
),
),
),
],
),
SizedBox(height: 24),

// Full Name Input
TextFormField(
controller: _nameController,
decoration: InputDecoration(
labelText: 'Nom Complet / Full Name',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
SizedBox(height: 16),

// Email Input
TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
labelText: 'Adresse Email',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
SizedBox(height: 16),

// NEW DYNAMIC PHONE INPUT (Removes forced +221 so anyone can type their own code)
TextFormField(
controller: _phoneController,
keyboardType: TextInputType.phone,
decoration: InputDecoration(
labelText: 'Numéro de Téléphone',
hintText: 'Ex: +224... ou +221...',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
prefixIcon: Icon(Icons.phone, color: Color(0xFF2E5A27)),
),
),
SizedBox(height: 30),

// THE UBER-STYLE SMART BUTTON
SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: isOnline ? Colors.red : Color(0xFF2E5A27), // Red if online, Green if offline
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
onPressed: () {
// This is the magic flip switch!
setState(() {
isOnline = !isOnline;
});

if (isOnline) {
print('🚀 Ignition! Driver went ONLINE.');
sendLiveLocation(); // FIRE THE SIGNAL!
} else {
print('💤 Driver went OFFLINE.');
}
},
child: Text(
isOnline ? 'GO OFFLINE (STOP REQUESTS)' : 'GO ONLINE',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),
),
),
],
),
),
),
);
}
}
