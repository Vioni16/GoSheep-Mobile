import 'package:flutter/material.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  static const gradients = [
    LinearGradient(colors: [Color(0xFF2044BD), Color(0xFF66BB6A)]),
    LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF2044BD)]),
    LinearGradient(colors: [Color(0xFF2044BD), Color(0xFF66BB6A)]),
    LinearGradient(colors: [Color(0xFF2044BD), Color(0xFF66BB6A)]),
  ];

  @override
  Widget build(BuildContext context) {
    final menus = [
      {"icon": Icons.agriculture, "label": "Manajemen\nKandang"},
      {"icon": Icons.favorite, "label": "Riwayat\nKawin"},
      {"icon": Icons.pets, "label": "Riwayat\nTernak"},
      {"icon": Icons.bar_chart, "label": "Laporan"},
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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(menus.length, (index) {
            return _MenuItemWidget(
              icon: menus[index]["icon"] as IconData,
              label: menus[index]["label"] as String,
              gradient: gradients[index],
              onTap: () {
                print("Klik ${menus[index]["label"]}");
              },
            );
          }),
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

              splashColor: Colors.black.withOpacity(0.2),
              highlightColor: Colors.black.withOpacity(0.1),

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
