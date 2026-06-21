import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gosheep_mobile/core/widgets/async_state_sliver.dart';
import 'package:gosheep_mobile/core/widgets/no_connection.dart';
import 'package:gosheep_mobile/core/widgets/app_banner.dart';
import 'package:gosheep_mobile/data/models/sheep_breeding.dart';
import 'package:gosheep_mobile/features/breeding/providers/breeding_provider.dart';
import 'package:gosheep_mobile/features/sheep/widgets/sheep_card_skeleton.dart';
import 'package:gosheep_mobile/core/widgets/app_refresh_indicator.dart';
import 'package:gosheep_mobile/features/breeding/widgets/breeding_sheep_card.dart';
import 'package:gosheep_mobile/features/breeding/widgets/breeding_recommendation_sheet.dart';

class BreedingScreen extends StatelessWidget {
  const BreedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreedingProvider(),
      child: const _BreedingScreenView(),
    );
  }
}

class _BreedingScreenView extends StatefulWidget {
  const _BreedingScreenView();

  @override
  State<_BreedingScreenView> createState() => _BreedingScreenViewState();
}

class _BreedingScreenViewState extends State<_BreedingScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BreedingProvider>().loadSheepList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BreedingProvider>();

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: AppBanner(
                backgroundColor: const Color(0xFF0F5132),
                pillLabel: 'Breeding Smart',
                title: 'Rekomendasi Perkawinan',
                subtitle:
                    'Temukan pasangan domba terbaik guna meningkatkan kualitas genetik anakan dan menghindari perkawinan sedarah.',
                decorIcon: Icons.auto_awesome_rounded,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  labelColor: const Color(0xFF0F5132),
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      height: 36,
                      text: 'Betina (Indukan)',
                    ),
                    Tab(
                      height: 36,
                      text: 'Jantan',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildSheepTabList(provider, 'female'),
                  _buildSheepTabList(provider, 'male'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheepTabList(BreedingProvider provider, String gender) {
    final list = gender == 'female' ? provider.femaleList : provider.maleList;

    return AppRefreshIndicator(
      onRefresh: provider.loadSheepList,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: AsyncStateSliver<SheepBreeding>(
              isLoading: provider.isLoadingList,
              error: provider.listError,
              data: list,
              onLoading: () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: SheepCardSkeleton(),
                  ),
                ),
              ),
              onError: (err) => SliverFillRemaining(
                hasScrollBody: false,
                child: NoConnection(
                  onRetry: [provider.loadSheepList],
                  description: err,
                ),
              ),
              onEmpty: () => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets_rounded,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tidak ada data domba',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onSuccess: (data) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final sheep = data[index];
                    return BreedingSheepCard(
                      sheep: sheep,
                      onTap: () =>
                          _handleSheepSelection(context, provider, sheep),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSheepSelection(
    BuildContext context,
    BreedingProvider provider,
    SheepBreeding sheep,
  ) {
    provider.selectSheep(sheep);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: provider,
          child: const BreedingRecommendationSheet(),
        );
      },
    );
  }
}
