import 'package:flutter/material.dart';

void main() {
runApp(const AfrounitedRiderApp());
}

class AfrounitedRiderApp extends StatelessWidget {
const AfrounitedRiderApp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Afrounited Rider',
theme: ThemeData(
primarySwatch: Colors.blue,
fontFamily: 'Roboto',
),
home: const RiderHomeScreen(),
debugShowCheckedModeBanner: false,
);
}
}

class RiderHomeScreen extends StatefulWidget {
const RiderHomeScreen({Key? key}) : super(key: key);

@override
State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
String selectedWallet = 'Orange Money';
final TextEditingController _phoneController = TextEditingController(text: '00224629135060');

// Anti-Fraud Verification Modal Trigger
void _showSafetyVerificationProtocol(BuildContext context) {
showDialog(
context: context,
barrierDismissible: false,
builder: (BuildContext context) {
return AlertDialog(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
title: Row(
children: const [
Icon(Icons.shield, color: Colors.red, size: 28),
SizedBox(width: 8),
Text('CONTRÔLE DE SÉCURITÉ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF991B1B))),
],
),
content: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: const [
Text(
'AVANT DE MONTER DANS LE VÉHICULE:',
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
),
SizedBox(height: 10),
Text('1. Vérifiez que le visage du chauffeur correspond à la photo de profil de l\'application.'),
SizedBox(height: 6),
Text('2. Confirmez que le numéro de plaque d\'immatriculation correspond exactement.'),
],
),
actions: [
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
),
onPressed: () {
Navigator.of(context).pop();
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Recherche d\'un chauffeur sécurisé Afrounited...')),
);
},
child: const Text('Je confirme la vérification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
),
],
);
},
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Afrounited Safe Ride', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
backgroundColor: const Color(0xFF0284C7),
centerTitle: true,
elevation: 2,
),
body: Stack(
children: [
// 1. Interactive Map Container Placeholder (Will connect to Google Maps API later)
Container(
color: const Color(0xFFE2E8F0),
child: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: const [
Icon(Icons.map, size: 64, color: Color(0xFF94A3B8)),
SizedBox(height: 8),
Text('GPS Mapping System Placeholder', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
Text('Conakry, Guinea', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
],
),
),
),

// 2. Sliding Payment Box (Bottom Sheet UI Layout)
Align(
alignment: Alignment.bottomCenter,
child: Container(
padding: const EdgeInsets.all(20),
decoration: const BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.only(
topLeft: Radius.circular(24),
topRight: Radius.circular(24),
),
boxShadow: [
BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
],
),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Mode de Paiement',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
),
const SizedBox(height: 12),

// Orange Money Choice Card
GestureDetector(
onTap: () {
setState(() {
selectedWallet = 'Orange Money';
_phoneController.text = '00224629135060';
});
},
child: Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: selectedWallet == 'Orange Money' ? const Color(0xFFFFF7ED) : Colors.white,
border: Border.all(
color: selectedWallet == 'Orange Money' ? const Color(0xFFEA580C) : const Color(0xFFCBD5E1),
width: 2,
),
borderRadius: BorderRadius.circular(12),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.between,
children: [
const Text('🍊 Orange Money Guinee', style: TextStyle(fontWeight: FontWeight.bold)),
if (selectedWallet == 'Orange Money')
const Icon(Icons.check_circle, color: Color(0xFFEA580C)),
],
),
),
),
const SizedBox(height: 10),

// Wave Choice Card
GestureDetector(
onTap: () {
setState(() {
selectedWallet = 'Wave';
_phoneController.text = '+224-622-99-88-11';
});
},
child: Container(
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: selectedWallet == 'Wave' ? const Color(0xFFF0F9FF) : Colors.white,
border: Border.all(
color: selectedWallet == 'Wave' ? const Color(0xFF0284C7) : const Color(0xFFCBD5E1),
width: 2,
),
borderRadius: BorderRadius.circular(12),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.between,
children: [
const Text('🌊 Wave Mobile Money', style: TextStyle(fontWeight: FontWeight.bold)),
if (selectedWallet == 'Wave')
const Icon(Icons.check_circle, color: Color(0xFF0284C7)),
],
),
),
),
const SizedBox(height: 16),

// Phone Input Target Display
TextFormField(
controller: _phoneController,
readOnly: true,
decoration: InputDecoration(
labelText: 'Numéro de Facturation',
labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
filled: true,
fillColor: const Color(0xFFF1F5F9),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
prefixIcon: const Icon(Icons.phone_android),
),
),
const SizedBox(height: 20),

// Action Confirmation Trigger Button
SizedBox(
width: double.infinity,
height: 52,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF16A34A),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
onPressed: () => _showSafetyVerificationProtocol(context),
child: const Text(
'Commander Un Trajet Sécurisé',
style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
),
),
),
],
),
),
),
],
),
);
}
}
