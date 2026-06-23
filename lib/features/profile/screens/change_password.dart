import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/data/providers/user_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    final success = await provider.changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
      newPasswordConfirmation: _confirmController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi berhasil diubah')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal mengubah kata sandi'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: scheme.primary,
        centerTitle: true,
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: scheme.primary,
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Buat kata sandi baru',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Pastikan kata sandi minimal 8 karakter',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
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
                    const _SectionLabel('KATA SANDI'),
                    const SizedBox(height: 12),

                    CustomTextFormField(
                      icon: Icons.lock_outline,
                      label: "Kata Sandi Lama",
                      hint: "Masukkan kata sandi lama",
                      isPassword: true,
                      controller: _currentController,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Kata sandi lama wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      icon: Icons.lock_outline,
                      label: "Kata Sandi Baru",
                      hint: "Masukkan kata sandi baru",
                      isPassword: true,
                      controller: _newController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Kata sandi baru wajib diisi';
                        }
                        if (v.length < 8) {
                          return 'Minimal 8 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      icon: Icons.lock_outline,
                      label: "Konfirmasi Kata Sandi Baru",
                      hint: "Ulangi kata sandi baru",
                      isPassword: true,
                      controller: _confirmController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Konfirmasi wajib diisi';
                        }
                        if (v != _newController.text) {
                          return 'Konfirmasi tidak cocok';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.tips_and_updates_outlined,
                                size: 15,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Tips keamanan kata sandi',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          for (final tip in [
                            'Minimal 8 karakter',
                            'Kombinasi huruf besar, kecil, dan angka',
                            'Hindari menggunakan tanggal lahir atau nama',
                          ])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 13,
                                    color: Colors.blue.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    tip,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
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
                                "Simpan Kata Sandi",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
