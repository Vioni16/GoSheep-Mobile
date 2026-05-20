import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/Gosheep_profile_photo.png',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 30),

            const CustomTextFormField(
              icon: Icons.person_outline,
              label: "Nama Lengkap",
              hint: "Dhominica Riskana",
            ),

            const SizedBox(height: 16),

            const CustomTextFormField(
              icon: Icons.email_outlined,
              label: "Email",
              hint: "dhominica@farm.id",
            ),

            const SizedBox(height: 16),

            const CustomTextFormField(
              icon: Icons.phone_outlined,
              label: "Nomor Telepon",
              hint: "+62 812 3456 7890",
            ),

            const SizedBox(height: 16),

            const CustomTextFormField(
              icon: Icons.home_work_outlined,
              label: "Nama Peternakan",
              hint: "Mandiri Jaya Farm",
            ),

            const SizedBox(height: 16),

            const CustomTextFormField(
              icon: Icons.location_on_outlined,
              label: "Lokasi Peternakan",
              hint: "Batam, Kepulauan Riau",
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 97, 97, 97),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
