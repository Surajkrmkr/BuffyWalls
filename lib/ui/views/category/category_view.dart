import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../models/model_export.dart';
import '../../common/common_export.dart';
import '../../widgets/widget_export.dart';
import 'category_viewmodel.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoryViewModel>.reactive(
        viewModelBuilder: () => locator<CategoryViewModel>(),
        disposeViewModel: false,
        fireOnViewModelReadyOnce: true,
        builder: (context, viewModel, child) {
          return DefaultTabController(
            length: viewModel.categories.length,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                BuffyAppBar(
                  title: AppStrings.collectionTitle,
                  categories:
                      viewModel.categories.entries.map((e) => e.key).toList(),
                )
              ],
              body: viewModel.hasError
                  ? const Center(
                      child: Text(
                        "Error",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : _bodyUI(viewModel, context),
            ),
          );
        });
  }

  Widget _bodyUI(CategoryViewModel viewModel, BuildContext context) {
    return TabBarView(
      children: viewModel.categories.entries
          .map((category) => _wallListViewUI(category.value))
          .toList(),
    );
  }

  Widget _wallListViewUI(List<PopularWall> walls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: walls.length >= 20 ? 20 : walls.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final wall = walls[index];
        return BuffyImage(
          imageUrl: wall.compressUrl,
          isHot: wall.isHot,
          isPremium: wall.isPremium,
        );
      },
    );
  }
}
