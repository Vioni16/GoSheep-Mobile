import 'package:flutter/material.dart';
import '../widgets/profile_menu_item.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        centerTitle: false,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2E5D3F), 
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              "Pengaturan Akun",
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), 
            
            _buildGreenHeader("KEAMANAN & DATA"),
            const SizedBox(height: 12),
            _buildMenuCard([
              ProfileMenuItem(icon: Icons.lock_reset, title: "Ganti Kata Sandi", onTap: () {}),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ProfileMenuItem(icon: Icons.verified_user_outlined, title: "Status Akses Peternak", onTap: () {}),
            ]),

            const SizedBox(height: 32),

            _buildGreenHeader("PENGATURAN APLIKASI"),
            const SizedBox(height: 12),
            _buildMenuCard([
              ProfileMenuItem(icon: Icons.notifications_active_outlined, title: "Notifikasi Breeding", onTap: () {}),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ProfileMenuItem(icon: Icons.language, title: "Bahasa Sistem", onTap: () {}),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ProfileMenuItem(icon: Icons.cloud_done_outlined, title: "Sinkronisasi Data", onTap: () {}),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ProfileMenuItem(icon: Icons.info_outline, title: "Versi Aplikasi", onTap: () {}),
            ]),

            const SizedBox(height: 100), 
          ],
        ),
      ),
    );
  }

  Widget _buildGreenHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E5D3F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          color: Colors.white, 
          fontSize: 11,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}