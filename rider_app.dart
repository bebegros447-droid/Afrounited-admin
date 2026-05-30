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
primaryColor: Color(0xFF0056B3), // The Afrounited Blue!
scaffoldBackgroundColor: Colors.white, // Clean White Background
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

// The 4 Main Screens the customer can swipe between
static const List<Widget> _pages = <Widget>[
Center(child: Text('🌍 Home / Map Screen', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
Center(child: Text('🚕 Book a Taxi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
Center(child: Text('🍔 Order Food', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
Center(child: Text('👤 My Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
];

void _onItemTapped(int index) {
setState(() {
_selectedIndex = index;
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
backgroundColor: Color(0xFF0056B3), // Blue Header
title: Text(
'Afrounited',
style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
),
elevation: 0,
centerTitle: true,
),
body: _pages.elementAt(_selectedIndex),

// The Bottom Navigation Bar
bottomNavigationBar: BottomNavigationBar(
items: const <BottomNavigationBarItem>[
BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: 'Ride'),
BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Eat'),
BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
],
currentIndex: _selectedIndex,
selectedItemColor: Color(0xFF0056B3), // Turns Blue when tapped
unselectedItemColor: Colors.grey,
onTap: _onItemTapped,
type: BottomNavigationBarType.fixed,
),
);
}
}
