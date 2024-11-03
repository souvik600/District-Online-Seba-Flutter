import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/user_category_screen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersHomeScreen/users_home_screen.dart';
import 'package:district_online_service/Screens/UsersPanel/UsersProfileScreen/user_profile_screen.dart';
import 'package:flutter/material.dart';
import '../AppColors/AppColors.dart';
import '../Styles/BackGroundStyle.dart';
import '../Widgets/CustomDrawerWidget.dart';


class NavigationBerScreen extends StatefulWidget {
  final int? selectedIndex;

  NavigationBerScreen({this.selectedIndex});

  @override
  _NavigationBerScreenState createState() => _NavigationBerScreenState();
}

class _NavigationBerScreenState extends State<NavigationBerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Widget _currentScreen;
  late Widget _userHomeScreen;
  late Widget _UserCatagoriListScreen;
  late Widget _userProfileListScreen;
  int _selectedIndex = 0; // Add this line to keep track of the selected index
  bool _hideNavigationBar = false; // Flag to hide navigation bar

  @override
  void initState() {
    super.initState();

    _userHomeScreen = UsersHomeScreen();
    _UserCatagoriListScreen = UserCategoryScreen();
    _userProfileListScreen = UserProfileScreen();

    _currentScreen = _userHomeScreen; // Initialize with a default screen

    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
      _currentScreen = _selectedIndex == 0
          ? _userHomeScreen
          : _selectedIndex == 1
          ? _UserCatagoriListScreen
          : _userProfileListScreen;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
      _currentScreen = index == 0
          ? _userHomeScreen
          : index == 1
          ? _UserCatagoriListScreen
          : _userProfileListScreen;

      _hideNavigationBar = true; // Hide navigation bar on tap
    });

    // Reset the flag to show the navigation bar after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (_selectedIndex == index) {
          _hideNavigationBar = false; // Only reset if the index hasn't changed
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            ScreenBackground(context),
            _currentScreen,
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              left: 0,
              right: 0,
              bottom: _hideNavigationBar ? -kBottomNavigationBarHeight : 0,
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 26),
                    label: 'হোম',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list, size: 26),
                    label: 'ক্যাটাগরি',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_pin, size: 26),
                    label: 'প্রোফাইল',
                  ),
                ],
                currentIndex: _selectedIndex, // Set the selected index
                onTap: _onItemTapped,
                selectedItemColor:
                AppColors.pColor, // Change the color of the selected icon
                selectedFontSize:
                16, // Adjust the font size for the selected item
                unselectedFontSize:
                14, // Adjust the font size for the unselected items
                selectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        drawer: const Drawer(
          child: CustomDrawerWidget(),
        ),
      ),
    );
  }
}
