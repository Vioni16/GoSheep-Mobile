import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/data/providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    final success = await provider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal memperbarui profil'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final provider = context.watch<UserProvider>();
    final user = provider.user;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: scheme.primary,
        centerTitle: true,
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: scheme.primary,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: const CircleAvatar(
                              radius: 44,
                              backgroundImage: AssetImage(
                                'assets/images/Gosheep_profile_photo.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.name ?? '-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel('DATA DIRI'),
                      const SizedBox(height: 12),

                      CustomTextFormField(
                        icon: Icons.person_outline,
                        label: "Nama Lengkap",
                        hint: "Masukkan nama lengkap",
                        controller: _nameController,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        icon: Icons.email_outlined,
                        label: "Email",
                        hint: "Masukkan email",
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!v.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      const _SectionLabel('INFORMASI AKUN'),
                      const SizedBox(height: 12),

                      _ReadonlyInfo(
                        icon: Icons.shield_outlined,
                        label: 'Role',
                        value: user?.role ?? '-',
                      ),

                      const SizedBox(height: 28),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.amber.shade700,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Role akun hanya dapat diubah oleh administrator.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber.shade800,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: provider.isLoading ? null : _save,
                          child: provider.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Simpan Perubahan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

class _ReadonlyInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReadonlyInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black38),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
