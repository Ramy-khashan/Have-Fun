import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/core/widgets/empty.dart';
import 'package:havefun/core/widgets/loading_item.dart';
import 'package:havefun/modules/memes/view/widgets/memes_shape.dart';

import '../controller/memes_cubit.dart';

class MemesScreen extends StatelessWidget {
  const MemesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => MemesCubit()..getMemes(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "Memes",
          style: TextStyle(
            fontSize: getFont(40),
          ),
        )),
        body: BlocBuilder<MemesCubit, MemesState>(
          builder: (context, state) {
            final controller = MemesCubit.get(context);
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getMemes();
              },
              child: controller.isLoadingMemes
                  ? const LoadingItem()
                  : controller.memesList.isEmpty
                      ? const EmptyShape()
                      : ListView.separated(
                          // reverse: true,
                          padding: EdgeInsets.only(top: getHeight(10)),
                          itemBuilder: (context, index) => MemesShapeItem(
                              memesModel: controller.memesList[index]),
                          itemCount: BlocProvider.of<MemesCubit>(context)
                              .memesList
                              .length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: getHeight(15),
                          ),
                        ),
            );
          },
        ),
      ),
    );
  }
}
