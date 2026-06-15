import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/validators.dart';
import 'package:gosheep_mobile/core/widgets/animated_gradient_text.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _onRequestReset() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final userProvider = context.read<UserProvider>();

    final success = await userProvider.requestPasswordReset(email);

    if (!mounted) return;

    if (success) {
      ToastService.show(
        context,
        userProvider.errorMessage ?? 'Permintaan reset sandi terkirim',
        type: ToastType.success,
        duration: const Duration(seconds: 4),
        title: 'Berhasil',
      );
      Navigator.pop(context); // Kembali ke halaman login setelah berhasil
    } else {
      ToastService.show(
        context,
        userProvider.errorMessage ?? 'Gagal meminta reset sandi',
        type: ToastType.error,
        duration: const Duration(seconds: 3),
        title: 'Gagal',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Lupa Password',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/logo.png', height: 180),
                ),
                
                const SizedBox(height: 10),

                const Text(
                  'Masukkan email Anda yang terdaftar. Kami akan mengirimkan permintaan reset password ke admin.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                CustomTextFormField(
                  icon: Icons.email,
                  hint: 'Email',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: userProvider.isLoading ? null : _onRequestReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: userProvider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Kirim Permintaan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
