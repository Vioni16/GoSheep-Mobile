import 'package:flutter/material.dart';
import 'package:gosheep_mobile/routes/app_routes.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      {
        "icon": Icons.agriculture,
        "label": "Manajemen\nKandang",
        "onTap": () {
          Navigator.pushNamed(context, '/cage');
        },
      },
      {
        "icon": Icons.favorite,
        "label": "Riwayat\nKawin",
        "onTap": () {
          Navigator.pushNamed(context, '/breeding-history');
        },
      },
      {
        "icon": Icons.monitor_heart_rounded,
        "label": "Pemantauan\nKebuntingan",
        "onTap": () {
          Navigator.pushNamed(context, '/pregnancy-monitoring');
        },
      },
      {
        "icon": Icons.bar_chart,
        "label": "Laporan",
        "onTap": () {
          Navigator.pushNamed(context, '/report');
        },
      },
      {
        "icon": Icons.medical_services_rounded,
        "label": "Catatan\nKesehatan",
        "onTap": () {
          Navigator.pushNamed(context, '/health-history');
        },
      },
      {
        "icon": Icons.monitor_weight_outlined,
        "label": "Riwayat\nBerat Badan",
        "onTap": () {
          Navigator.pushNamed(context, '/weight-history');
        },
      },
      {
        "icon": Icons.archive_outlined,
        "label": "Ternak\nNonaktif",
        "onTap": () {
          Navigator.pushNamed(context, '/inactive-sheep');
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Menu Navigasi",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 115, 115, 115),
          ),
        ),

        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menus.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 3,
            crossAxisSpacing: 20,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            return _MenuItemWidget(
              icon: menus[index]["icon"] as IconData,
              label: menus[index]["label"] as String,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.8, 0.6],
                colors: [Color(0xFF0F5132), Color(0xFF8D6E63)],
              ),
              onTap: () {
                final onTap = menus[index]["onTap"] as VoidCallback;

                onTap();
              },
            );
          },
        ),
      ],
    );
  }
}

class _MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _MenuItemWidget({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: onTap,
              splashColor: Colors.black.withValues(alpha: 0.2),
              highlightColor: Colors.black.withValues(alpha: 0.1),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10.5, height: 1.2),
        ),
      ],
    );
  }
}
