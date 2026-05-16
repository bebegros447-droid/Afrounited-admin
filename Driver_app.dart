import 'package:flutter/material.dart';

void main() {
runApp(const AfrounitedDriverApp());
}

class AfrounitedDriverApp extends StatelessWidget {
const AfrounitedDriverApp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Afrounited Driver',
theme: ThemeData(
brightness: Brightness.dark, // Dark mode default for professional driver look
primaryColor: const Color(0xFF1E293B),
scaffoldBackgroundColor: const Color(0xFF0F172A),
),
home: const DriverHomeScreen(),
debugShowCheckedModeBanner: false,
);
}
}

class DriverHomeScreen extends StatefulWidget {
const DriverHomeScreen({Key? key}) : super(key: key);

@override
State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
double accumulatedEarnings = 120.50; // Syncs up with Mariama Barry's mock balance
String payoutMethod = 'Orange Money';
String payoutPhone = '+224-664-44-55-66';

void _dispatchPayoutRequest(BuildContext context) {
showModalBottomSheet(
context: context,
backgroundColor: const Color(0xFF1E293B),
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
),
builder: (BuildContext context) {
return Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Confirmer la Demande de Transfert',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
),
const SizedBox(height: 12),
Text(
'Montant à transférer : \$${accumulatedEarnings.toStringAsFixed(2)}',
style: const TextStyle(fontSize: 15, color: Color(0xFF38BDF8), fontGreyweight: FontWeight.bold),
),
const SizedBox(height: 6),
Text('Destination : $payoutMethod ($payoutPhone)', style: const TextStyle(color: Colors.white70)),
const SizedBox(height: 24),
SizedBox(
width: double.infinity,
height: 48,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFEA580C), // Orange Money signature color
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
),
onPressed: () {
Navigator.pop(context);
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: Colors.green,
content: Text('Demande envoyée au coffre-fort de l\'administrateur pour $payoutPhone !'),
),
);
},
child: const Text(
'Confirmer le Payout',
style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
),
),
)
],
),
);
},
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Afrounited Chauffeur', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
backgroundColor: const Color(0xFF0F172A),
centerTitle: true,
elevation: 0,
),
body: Padding(
padding: const EdgeInsets.all(20.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// 1. Earnings Tracker Card
Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [Color(0xFF1E293B), Color(0xFF334155)],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(16),
border: Border.all(color: const Color(0xFF475569)),
),
child: Column(
children: [
const Text(
'SOLDE TOTAL ACCRU',
style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600, letterSpacing: 1),
),
const SizedBox(height: 6),
Text(
'\$${accumulatedEarnings.toStringAsFixed(2)}',
style: const TextStyle(fontSize: 36, fontWeight: FontWeight.extrabold, color: Colors.white),
),
const SizedBox(height: 15),
SizedBox(
width: double.infinity,
height: 44,
child: ElevatedButton.icon(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFEA580C),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
),
icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
label: const Text('Demander un Transfert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
onPressed: () => _dispatchPayoutRequest(context),
),
),
],
),
),
const SizedBox(height: 25),

// 2. Wallet Config Settings Display
const Text(
'Configuration de Paiement Active',
style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
),
const SizedBox(height: 10),
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: const Color(0xFF1E293B),
borderRadius: BorderRadius.circular(12),
),
child: Row(
children: [
const Icon(Icons.phone_android, color: Color(0xFFEA580C), size: 32),
const SizedBox(width: 14),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(payoutMethod, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
const SizedBox(height: 2),
Text(payoutPhone, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
],
),
const Spacer(),
const Text('Vérifié', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
],
),
),
const SizedBox(height: 30),

// 3. Simulated Active Operations Feed
const Text(
'Flux de Course en Direct',
style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
),
const SizedBox(height: 10),
Expanded(
child: ListView(
children: [
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: const Color(0xFF1E293B),
borderRadius: BorderRadius.circular(12),
border: Border.all(color: Colors.green.withOpacity(0.3)),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.between,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: const [
Text('📦 Livraison de Nourriture', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
SizedBox(height: 4),
Text('Resto: Le Ciel Conakry (Dixinn)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
],
),
Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
child: const Text('Prêt', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
)
],
),
),
],
),
),
],
),
),
);
}
}
