import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/confirmation_dialog.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/data/providers/user_provider.dart';
import 'package:gosheep_mobile/features/profile/screens/change_password.dart';
import 'package:gosheep_mobile/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        'Apakah kamu yakin ingin keluar dari akun ini?',
        subtitle: 'Kamu perlu login kembali untuk mengakses aplikasi.',
        icon: Icons.logout_rounded,
        onTap: () {
          userProvider.logout();
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: scheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        'assets/images/Gosheep_profile_photo.png',
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dhominica Riskana",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Mandiri Jaya Farm",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Batam, Kepulauan Riau",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('INFORMASI AKUN'),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    hint: 'dhominica@farm.id',
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    icon: Icons.app_registration,
                    label: 'Tanggal Bergabung',
                    hint: '30 Mei 2026',
                    enabled: false,
                  ),

                  const SizedBox(height: 28),

                  const _SectionLabel('PENGATURAN'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.edit_outlined,
                          title: "Edit Profil",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          ),
                        ),
                        _Divider(),
                        ProfileMenuItem(
                          icon: Icons.lock_reset_rounded,
                          title: "Ubah Kata Sandi",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen(),
                            ),
                          ),
                        ),
                        _Divider(),
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: "Bantuan",
                          onTap: () {},
                        ),
                        _Divider(),
                        ProfileMenuItem(
                          icon: Icons.info_outline,
                          title: "Tentang Aplikasi",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.15),
                      ),
                    ),
                    child: ProfileMenuItem(
                      icon: Icons.logout,
                      title: "Keluar Akun",
                      textColor: Colors.red,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.black38,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.black.withValues(alpha: 0.06),
    );
  }
}
