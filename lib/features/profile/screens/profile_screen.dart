import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/profile/screens/account_settings_screen.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          "Apakah Anda yakin ingin keluar dari akun ini?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/user_placeholder.png'),
              ),
            ),
            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Column(
                children: const [
                  _InfoRow(icon: Icons.person_outline, label: "Nama Lengkap", value: "Dhominica Riskana"),
                  Divider(height: 1),
                  _InfoRow(icon: Icons.email_outlined, label: "Email", value: "dhominica@farm.id"),
                  Divider(height: 1),
                  _InfoRow(icon: Icons.phone_outlined, label: "Nomor Telepon", value: "+62 812 3456 7890"),
                  Divider(height: 1),
                  _InfoRow(icon: Icons.agriculture_outlined, label: "Nama Peternakan", value: "Mandiri Jaya Farm"),
                  Divider(height: 1),
                  _InfoRow(icon: Icons.location_on_outlined, label: "Lokasi Peternakan", value: "Batam, Kepulauan Riau"),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("PENGATURAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.edit_square, 
                    title: "Edit Profil", 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
                  ),
                  ProfileMenuItem(icon: Icons.settings_outlined, title: "Pengaturan Akun", onTap: () {
                    Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const AccountSettingsScreen())
                      );
                  }),
                  ProfileMenuItem(icon: Icons.help_outline, title: "Bantuan", onTap: () {}),
                  ProfileMenuItem(icon: Icons.info_outline, title: "Tentang Aplikasi", onTap: () {}),
                  ProfileMenuItem(
                    icon: Icons.logout, 
                    title: "Keluar Akun", 
                    textColor: Colors.red, 
                    onTap: () => _showLogoutDialog(context)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF759784), size: 26),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D3132))),
            ],

          ),
        ],
      ),
    );
  }
}
