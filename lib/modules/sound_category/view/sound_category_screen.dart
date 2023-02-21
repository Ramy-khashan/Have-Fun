import 'package:flutter/material.dart';
import 'package:havefun/data/category_type.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../sound_category_item/view/music_category_item_screen.dart';

class SoundCategoryScreen extends StatelessWidget {
  const SoundCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Music Category",
          style: TextStyle(
            fontSize: getFont(40),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            CategoryType.category.length,
            (index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicCaategoryItemScreen(
                        categoryType: CategoryType.category[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(
                  getWidth(15),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      spreadRadius: 2,
                      color: AppColors.secondryColor.withOpacity(.5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(getWidth(10)),
                  child: Column(
                    children: [
                      Image.asset(
                        CategoryType.categoryImage[index],
                        height: getHeight(130),
                      ),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        CategoryType.category[index][0].toUpperCase() +
                            CategoryType.category[index]
                                .split(CategoryType.category[index][0])[1],
                        style: TextStyle(
                          fontSize: getFont(24),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
