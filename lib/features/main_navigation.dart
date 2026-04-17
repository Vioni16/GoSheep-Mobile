import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/floating_logo.dart';
import 'package:gosheep_mobile/features/authentication/screens/login_screen.dart';
import 'package:gosheep_mobile/features/breeding/screens/breeding_screen.dart';
import 'package:gosheep_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:gosheep_mobile/features/profile/screens/profile_screen.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _navIndex = 0;

  static const List<Widget> _pages = [
    DashboardPage(),
    SheepScreen(),
    BreedingScreen(),
    ProfileScreen(),
  ];

  static const _activeColor = Color(0xFF0F5132);
  static const _inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'GoSheep',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        shape: _navIndex == 0
            ? null
            : const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25)
          )
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        leading: FloatingLogo(height: 5,),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
            icon: const Icon(Icons.notifications_outlined, color: Colors.white,),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _navIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(bottomPadding),
    );
  }

  Widget _buildBottomNav(double bottomPadding) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  _buildNavItem(0, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Beranda'),
                  _buildNavItem(1, Icons.pets_rounded, Icons.pets_outlined, 'Domba'),
                  const Expanded(child: SizedBox()),
                  _buildNavItem(2, Icons.favorite_rounded, Icons.favorite_border_rounded, 'Breeding'),
                  _buildNavItem(3, Icons.person_rounded, Icons.person_outlined, 'Profil'),
                ],
              ),

              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Center(child: _buildFab()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: _activeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {},
          child: const Icon(Icons.document_scanner_outlined, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _navIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _navIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              size: 26,
              color: isActive ? _activeColor : _inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? _activeColor : _inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}