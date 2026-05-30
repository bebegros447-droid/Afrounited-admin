import 'package:flutter/material.dart';

void main() {
runApp(CustomerApp());
}

class CustomerApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Afrounited',
theme: ThemeData(
primaryColor: Color(0xFF0056B3), // The Afrounited Blue
scaffoldBackgroundColor: Colors.grey[100], // Soft background so the white buttons pop
fontFamily: 'Roboto',
),
home: CustomerHomePage(),
);
}
}

class CustomerHomePage extends StatefulWidget {
@override
_CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
int _selectedIndex = 0;

void _onItemTapped(int index) {
setState(() {
_selectedIndex = index;
});
}

@override
Widget build(BuildContext context) {
// The 4 Main Screens
final List<Widget> _pages = <Widget>[
HomeScreen(
onNavigate: (index) {
_onItemTapped(index); // This lets the Home buttons magically jump to other tabs!
},
), // 🌍 HOME
Center(child: Text('🚕 Ride Map Screen (Coming Next!)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), // 🚕 RIDE
Center(child: Text('🍔 Restaurant Feed (Coming Soon)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), // 🍔 EAT
Center(child: Text('👤 User Profile & Wallets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), // 👤 ACCOUNT
];

return Scaffold(
appBar: AppBar(
backgroundColor: Color(0xFF0056B3),
title: Text(
'Afrounited',
style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
),
elevation: 0,
centerTitle: true,
),
body: _pages.elementAt(_selectedIndex),

bottomNavigationBar: BottomNavigationBar(
items: const <BottomNavigationBarItem>[
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: 'Ride'),
BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Eat'),
BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
],
currentIndex: _selectedIndex,
selectedItemColor: Color(0xFF0056B3),
unselectedItemColor: Colors.grey,
onTap: _onItemTapped,
type: BottomNavigationBarType.fixed,
),
);
}
}

// --- NEW: THE HOME DASHBOARD UI ---
class HomeScreen extends StatelessWidget {
final Function(int) onNavigate;

HomeScreen({required this.onNavigate});

@override
Widget build(BuildContext context) {
return SingleChildScrollView(
padding: EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Greeting
Text(
'Where to?',
style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
),
SizedBox(height: 24),

// Super-App Action Grid
Row(
children: [
// Ride Button
Expanded(
child: GestureDetector(
onTap: () => onNavigate(1), // Jumps to the Ride tab when clicked
child: Container(
padding: EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
),
child: Column(
children: [
Icon(Icons.local_taxi, size: 60, color: Color(0xFF0056B3)),
SizedBox(height: 12),
Text('Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
],
),
),
),
),
SizedBox(width: 16),
// Eat Button
Expanded(
child: GestureDetector(
onTap: () => onNavigate(2), // Jumps to the Eat tab when clicked
child: Container(
padding: EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
),
child: Column(
children: [
Icon(Icons.fastfood, size: 60, color: Color(0xFF0056B3)),
SizedBox(height: 12),
Text('Eat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
],
),
),
),
),
],
),
SizedBox(height: 32),

// Promotional Banner
Container(
width: double.infinity,
padding: EdgeInsets.all(20),
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xFF0056B3), Color(0xFF003D82)],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(16),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Welcome to Afrounited!',
style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
),
SizedBox(height: 8),
Text(
'Your all-in-one app for transportation and delivery services.',
style: TextStyle(color: Colors.white70, fontSize: 14),
),
],
),
),
],
),
);
}
}
