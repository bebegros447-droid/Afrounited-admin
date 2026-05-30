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
  // Universal Location Memory
final TextEditingController _countryController = TextEditingController();
final TextEditingController _regionController = TextEditingController();

// Vehicle Memory (For Taxi & Delivery)
final TextEditingController _vehicleMakeController = TextEditingController();
final TextEditingController _vehicleModelController = TextEditingController();
final TextEditingController _plateNumberController = TextEditingController();
  // The Vehicle Dropdown Memory
String vehicleType = 'Car'; // Defaults to Car
final TextEditingController _vehicleYearController = TextEditingController();
  // The Photo Upload Memory (True means they uploaded a picture)
bool hasProfilePic = false;
bool hasIdCard = false;
bool hasVehiclePhotos = false;
bool hasStorePhotos = false;

  // The Payout Wallet Memory (How they get paid!)
String selectedWallet = 'Orange Money'; // Default to Orange Money
final TextEditingController _walletNumberController = TextEditingController();

// Business Memory (For Stores & Restaurants)
final TextEditingController _storeNameController = TextEditingController();
final TextEditingController _storeAddressController = TextEditingController();

bool isOnline = false; // By default, the driver starts offline
  String workerRole = 'Taxi'; // Default path. Can switch to 'Delivery' or 'Store'

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



// THE PATH SELECTOR: Taxi | Delivery | Store
Container(
padding: EdgeInsets.all(4),
decoration: BoxDecoration(
color: Colors.grey.shade200,
borderRadius: BorderRadius.circular(12),
),
child: Row(
children: [
// 1. TAXI BUTTON
Expanded(
child: GestureDetector(
onTap: () {
setState(() { workerRole = 'Taxi'; });
},
child: Container(
padding: EdgeInsets.symmetric(vertical: 12),
decoration: BoxDecoration(
color: workerRole == 'Taxi' ? Color(0xFF2E5A27) : Colors.transparent,
borderRadius: BorderRadius.circular(8),
),
child: Text(
'Taxi',
textAlign: TextAlign.center,
style: TextStyle(
color: workerRole == 'Taxi' ? Colors.white : Colors.black54,
fontWeight: FontWeight.bold,
),
),
),
),
),

// 2. DELIVERY BUTTON
Expanded(
child: GestureDetector(
onTap: () {
setState(() { workerRole = 'Delivery'; });
},
child: Container(
padding: EdgeInsets.symmetric(vertical: 12),
decoration: BoxDecoration(
color: workerRole == 'Delivery' ? Color(0xFF2E5A27) : Colors.transparent,
borderRadius: BorderRadius.circular(8),
),
child: Text(
'Delivery',
textAlign: TextAlign.center,
style: TextStyle(
color: workerRole == 'Delivery' ? Colors.white : Colors.black54,
fontWeight: FontWeight.bold,
),
),
),
),
),

// 3. STORE BUTTON
Expanded(
child: GestureDetector(
onTap: () {
setState(() { workerRole = 'Store'; });
},
child: Container(
padding: EdgeInsets.symmetric(vertical: 12),
decoration: BoxDecoration(
color: workerRole == 'Store' ? Color(0xFF2E5A27) : Colors.transparent,
borderRadius: BorderRadius.circular(8),
),
child: Text(
'Store / Food',
textAlign: TextAlign.center,
style: TextStyle(
color: workerRole == 'Store' ? Colors.white : Colors.black54,
fontWeight: FontWeight.bold,
),
),
),
),
),
],
),
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




  // 🌍 UNIVERSAL LOCATION (Everyone sees this)
TextFormField(
controller: _countryController,
decoration: InputDecoration(
labelText: 'Country (e.g., Guinea)',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
SizedBox(height: 16),
TextFormField(
controller: _regionController,
decoration: InputDecoration(
labelText: 'Region / Prefecture / Village',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
SizedBox(height: 24),

// 🚗 THE SHAPE-SHIFTER: TAXI & DELIVERY ONLY
if (workerRole == 'Taxi' || workerRole == 'Delivery') ...[
Text(
'Vehicle Information',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
),
SizedBox(height: 16),

// THE VEHICLE DROPDOWN
DropdownButtonFormField<String>(
value: vehicleType,
decoration: InputDecoration(
labelText: 'Vehicle Type',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
items: ['Car', 'Motorcycle', 'Scooter', 'E-bike'].map((String type) {
return DropdownMenuItem<String>(
value: type,
child: Text(type),
);
}).toList(),
onChanged: (String? newValue) {
setState(() {
vehicleType = newValue!;
});
},
),
SizedBox(height: 16),

// If it's NOT an E-bike, ask for Make and Plate Number
if (vehicleType != 'E-bike') ...[
TextFormField(
controller: _vehicleMakeController,
decoration: InputDecoration(
labelText: 'Vehicle Make (e.g., Toyota, Honda)',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
SizedBox(height: 16),
TextFormField(
controller: _plateNumberController,
decoration: InputDecoration(
labelText: 'Plate Number / License',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
],

// If it IS an E-bike, ONLY ask for the Year
if (vehicleType == 'E-bike') ...[
TextFormField(
controller: _vehicleYearController,
keyboardType: TextInputType.number,
decoration: InputDecoration(
labelText: 'E-bike Year (e.g., 2023)',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
],
SizedBox(height: 24),
],

// 🍔 THE SHAPE-SHIFTER: STORE ONLY
if (workerRole == 'Store') ...[
Text(
'Business Information',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
),
SizedBox(height: 16),
TextFormField(
controller: _storeNameController,
decoration: InputDecoration(
labelText: 'Name of Restaurant / Store',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
SizedBox(height: 16),
TextFormField(
controller: _storeAddressController,
decoration: InputDecoration(
labelText: 'Exact Physical Address',
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
fillColor: Colors.white,
filled: true,
),
),
SizedBox(height: 24),
],
// 📸 THE PHOTO UPLOAD ENGINE
Text(
'Required Documents',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
),
SizedBox(height: 16),

// UNIVERSAL: Profile Picture (Everyone)
ListTile(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
tileColor: Colors.white,
leading: Icon(Icons.person, color: hasProfilePic ? Colors.green : Colors.grey),
title: Text('Profile Picture'),
subtitle: Text(hasProfilePic ? 'Uploaded Successfully' : 'Tap to upload'),
trailing: Icon(hasProfilePic ? Icons.check_circle : Icons.camera_alt, color: hasProfilePic ? Colors.green : Color(0xFF2E5A27)),
onTap: () {
setState(() { hasProfilePic = true; }); // Magic: Flips false to true!
},
),
SizedBox(height: 12),

// UNIVERSAL: ID Card (Everyone)
ListTile(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
tileColor: Colors.white,
leading: Icon(Icons.badge, color: hasIdCard ? Colors.green : Colors.grey),
title: Text('Government ID'),
subtitle: Text(hasIdCard ? 'Uploaded Successfully' : 'Tap to upload front & back'),
trailing: Icon(hasIdCard ? Icons.check_circle : Icons.camera_alt, color: hasIdCard ? Colors.green : Color(0xFF2E5A27)),
onTap: () {
setState(() { hasIdCard = true; }); // Magic: Flips false to true!
},
),
SizedBox(height: 12),

// 🚗 THE SHAPE-SHIFTER: VEHICLE PHOTOS (Taxi/Delivery Only)
if (workerRole == 'Taxi' || workerRole == 'Delivery') ...[
ListTile(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
tileColor: Colors.white,
leading: Icon(Icons.directions_car, color: hasVehiclePhotos ? Colors.green : Colors.grey),
title: Text('Vehicle Photos'),
subtitle: Text(hasVehiclePhotos ? 'Uploaded Successfully' : 'Tap to upload 4 angles'),
trailing: Icon(hasVehiclePhotos ? Icons.check_circle : Icons.camera_alt, color: hasVehiclePhotos ? Colors.green : Color(0xFF2E5A27)),
onTap: () {
setState(() { hasVehiclePhotos = true; }); // Magic: Flips false to true!
},
),
SizedBox(height: 12),
],

// 🍔 THE SHAPE-SHIFTER: STORE PHOTOS (Store Only)
if (workerRole == 'Store') ...[
ListTile(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
tileColor: Colors.white,
leading: Icon(Icons.storefront, color: hasStorePhotos ? Colors.green : Colors.grey),
title: Text('Store & Menu Photos'),
subtitle: Text(hasStorePhotos ? 'Uploaded Successfully' : 'Tap to upload inside/outside/menu'),
trailing: Icon(hasStorePhotos ? Icons.check_circle : Icons.camera_alt, color: hasStorePhotos ? Colors.green : Color(0xFF2E5A27)),
onTap: () {
setState(() { hasStorePhotos = true; }); // Magic: Flips false to true!
},
),
SizedBox(height: 12),
],
SizedBox(height: 24),
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
