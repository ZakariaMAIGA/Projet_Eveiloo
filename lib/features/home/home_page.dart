import 'package:eveiloo_enfant/models/activity_model.dart.dart';
import 'package:eveiloo_enfant/widgets/activity_card.dart';
import 'package:eveiloo_enfant/widgets/app_bottom_nav_bar.dart';
import 'package:eveiloo_enfant/widgets/chil_card.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

 
import '../../models/child_model.dart';

 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChildModel> children = [
      ChildModel(
        id: '1',
        name: 'Megumi',
        age: 6,
        level: 4,
        progression: 0.75,
        imageUrl: AppAssets.megumi,
      ),
      ChildModel(
        id: '2',
        name: 'Panda',
        age: 6,
        level: 4,
        progression: 0.75,
        imageUrl: AppAssets.panda,
      ),

        ChildModel(
        id: '2',
        name: 'Panda',
        age: 6,
        level: 4,
        progression: 0.75,
        imageUrl: AppAssets.panda,
      ),
    ];
    

    final List<ActivityModel> activities = [
      ActivityModel(
        id: '1',
        title: 'Puzzle des animaux',
        description: 'Megumi a terminé',
        imageUrl: AppAssets.puzzle,
      ),
      ActivityModel(
        id: '2',
        title: 'Corps Humain',
        description: 'Kenjaku a regardé un tutoriel',
        imageUrl: AppAssets.jouet2,
      ),
      
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 38),

              // =============================
              // HEADER
              // =============================

              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Text(
                  AppConstants.homeGreeting,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Text(
                  AppConstants.childrenPreview,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.2,
                    color: AppColors.darkText,
                  ),
                ),
              ),

              const SizedBox(height: 65),

              // =============================
              // LISTE DES ENFANTS
              // =============================

              SizedBox(
                height: 295,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  itemCount: children.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 24),
                  itemBuilder: (context, index) {
                    final child = children[index];

                    return ChildCard(
                      child: child,
                      progressColor: index == 0
                          ? AppColors.pinkProgress
                          : AppColors.blueProgress,
                    );
                  },
                ),
              ),

              const SizedBox(height: 36),

              // =============================
              // ACTIVITÉS RÉCENTES
              // =============================

              const Padding(
                padding: EdgeInsets.only(
                  left: 52,
                ),
                child: Text(
                  AppConstants.recentActivities,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // =============================
              // LISTE DES ACTIVITÉS
              // =============================

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return ActivityCard(
                    activity: activities[index],
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}