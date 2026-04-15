import 'package:flutter/material.dart';
import '../widgets/breeding_search_bar.dart';
import '../widgets/sheep_card.dart';

class BreedingScreen extends StatefulWidget {
  const BreedingScreen({super.key});

  @override
  State<BreedingScreen> createState() => _BreedingScreenState();
}

class _BreedingScreenState extends State<BreedingScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Data dummy domba
  final List<Map<String, dynamic>> _dummyData = [
    {'eartag': 'M001', 'gender': 'Jantan', 'breed': 'Domba Garut'},
    {'eartag': 'M002', 'gender': 'Jantan', 'breed': 'Domba Texel'},
    {'eartag': 'M003', 'gender': 'Jantan', 'breed': 'Domba Merino'},
    {'eartag': 'F001', 'gender': 'Betina', 'breed': 'Domba Garut'},
    {'eartag': 'F002', 'gender': 'Betina', 'breed': 'Domba Merino'},
    {'eartag': 'F003', 'gender': 'Betina', 'breed': 'Domba Texel'},
    {'eartag': 'F004', 'gender': 'Betina', 'breed': 'Domba Lokal'},
  ];

  final List<int> _matchScores = [97, 91, 86];

  Map<String, dynamic>? _searchedSheep;
  List<Map<String, dynamic>> _recommendations = [];
  String _screenState = 'idle'; // idle | found | not_found

  void _handleSearch() {
    final query = _searchController.text.trim().toUpperCase();
    if (query.isEmpty) return;

    final found = _dummyData.where((s) => s['eartag'] == query).toList();

    if (found.isEmpty) {
      setState(() {
        _screenState = 'not_found';
        _searchedSheep = null;
        _recommendations = [];
      });
      return;
    }

    final sheep = found.first;
    final oppositeGender = sheep['gender'] == 'Jantan' ? 'Betina' : 'Jantan';
    final partners = _dummyData
        .where((s) => s['gender'] == oppositeGender)
        .take(3)
        .toList();

    setState(() {
      _screenState = 'found';
      _searchedSheep = sheep;
      _recommendations = partners;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7F6),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSearchRow(),
              const SizedBox(height: 32),
              if (_screenState == 'idle') _buildIdle(),
              if (_screenState == 'not_found') _buildNotFound(),
              if (_screenState == 'found') _buildResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Sistem Rekomendasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Masukkan eartag domba untuk mendapatkan rekomendasi pasangan breeding terbaik.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: BreedingSearchBar(
            controller: _searchController,
            onSearch: _handleSearch,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _handleSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              elevation: 0,
            ),
            child: const Icon(Icons.search, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildIdle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Icon(Icons.pets_rounded, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Cari domba berdasarkan eartag',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Contoh: M001, F001, M002',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 72, color: Colors.red[200]),
            const SizedBox(height: 16),
            Text(
              'Domba tidak ditemukan',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Eartag "${_searchController.text}" tidak ada dalam data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final sheep = _searchedSheep!;
    final isJantan = sheep['gender'] == 'Jantan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Domba yang dicari
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isJantan ? Icons.male : Icons.female,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sheep['eartag'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${sheep['breed']} · ${sheep['gender']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white70,
                size: 22,
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Text(
          'Rekomendasi Pasangan (${_recommendations.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Difilter: gender ${isJantan ? "Betina" : "Jantan"} yang kompatibel',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        const SizedBox(height: 16),

        // List rekomendasi
        for (int i = 0; i < _recommendations.length; i++)
          SheepCard(
            eartag: _recommendations[i]['eartag'] as String,
            breed: _recommendations[i]['breed'] as String,
            gender: _recommendations[i]['gender'] as String,
            matchScore: _matchScores[i % _matchScores.length],
          ),
      ],
    );
  }
}