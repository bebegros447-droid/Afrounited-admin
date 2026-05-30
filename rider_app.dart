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
primaryColor: Color(0xFF0056B3),
scaffoldBackgroundColor: Colors.grey[100],
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
HomeScreen(onNavigate: _onItemTapped), // 🌍 HOME
RideScreen(), // 🚕 RIDE
EatScreen(), // 🍔 EAT (NEW!)
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

// --- THE HOME DASHBOARD UI ---
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
Text('Where to?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
SizedBox(height: 24),
Row(
children: [
Expanded(
child: GestureDetector(
onTap: () => onNavigate(1),
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
Expanded(
child: GestureDetector(
onTap: () => onNavigate(2),
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
Text('Welcome to Afrounited!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
SizedBox(height: 8),
Text('Your all-in-one app for transportation and delivery services.', style: TextStyle(color: Colors.white70, fontSize: 14)),
],
),
),
],
),
);
}
}

// --- THE RIDE SCREEN UI ---
class RideScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Stack(
children: [
Container(
color: Colors.blueGrey[100],
child: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.map, size: 100, color: Colors.blueGrey[300]),
SizedBox(height: 16),
Text('Map Loading...', style: TextStyle(color: Colors.blueGrey[500], fontSize: 18)),
],
),
),
),
Positioned(
top: 20,
left: 16,
right: 16,
child: Container(
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
decoration: InputDecoration(
icon: Icon(Icons.my_location, color: Colors.green),
hintText: 'Current Location (e.g., Kaloum)',
border: InputBorder.none,
),
),
Divider(height: 24, thickness: 1),
TextField(
decoration: InputDecoration(
icon: Icon(Icons.location_on, color: Colors.red),
hintText: 'Where to? (e.g., Dixinn, Ratoma)',
border: InputBorder.none,
),
),
],
),
),
),
],
);
}
}

// --- NEW: THE EAT SCREEN UI ---
class EatScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Search Bar Header
Container(
padding: EdgeInsets.all(16),
color: Color(0xFF0056B3),
child: TextField(
decoration: InputDecoration(
hintText: 'Search for restaurants or dishes...',
fillColor: Colors.white,
filled: true,
prefixIcon: Icon(Icons.search),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
contentPadding: EdgeInsets.symmetric(vertical: 0),
),
),
),

SizedBox(height: 16),

// Horizontal Categories
Padding(
padding: EdgeInsets.symmetric(horizontal: 16),
child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
),
SizedBox(height: 12),
Container(
height: 100,
child: ListView(
scrollDirection: Axis.horizontal,
padding: EdgeInsets.symmetric(horizontal: 16),
children: [
_buildCategoryCard(Icons.local_dining, 'Local'),
_buildCategoryCard(Icons.fastfood, 'Fast Food'),
_buildCategoryCard(Icons.local_cafe, 'Cafes'),
_buildCategoryCard(Icons.bakery_dining, 'Bakery'),
],
),
),

SizedBox(height: 24),

// Featured Restaurants List
Padding(
padding: EdgeInsets.symmetric(horizontal: 16),
child: Text('Featured Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
),
SizedBox(height: 12),

_buildRestaurantCard('Le Bamako', 'Local & African', '4.8', '15-25 min'),
_buildRestaurantCard('Conakry Fried Chicken', 'Fast Food', '4.5', '20-30 min'),
_buildRestaurantCard('Shawarma Express', 'Lebanese', '4.7', '10-20 min'),
SizedBox(height: 20),
],
),
);
}

// Mini-Widget for the Category Boxes
Widget _buildCategoryCard(IconData icon, String title) {
return Container(
width: 80,
margin: EdgeInsets.only(right: 12),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(icon, size: 32, color: Color(0xFF0056B3)),
SizedBox(height: 8),
Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
],
),
);
}

// Mini-Widget for the Restaurant Feed
Widget _buildRestaurantCard(String name, String type, String rating, String time) {
return Container(
margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Fake Image Placeholder
Container(
height: 120,
decoration: BoxDecoration(
color: Colors.grey[300],
borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
),
child: Center(child: Icon(Icons.restaurant, size: 50, color: Colors.grey[500])),
),
Padding(
padding: EdgeInsets.all(12),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
SizedBox(height: 4),
Text(type, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
SizedBox(height: 8),
Row(
children: [
Icon(Icons.star, size: 16, color: Colors.orange),
SizedBox(width: 4),
Text(rating, style: TextStyle(fontWeight: FontWeight.bold)),
SizedBox(width: 16),
Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
SizedBox(width: 4),
Text(time, style: TextStyle(color: Colors.grey[600])),
],
),
],
),
)
],
),
);
}
}
