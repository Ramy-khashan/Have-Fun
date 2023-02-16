import 'package:flutter/material.dart';
import 'package:havefun/core/utils/app_colors.dart';

import '../size_config.dart';

showSheet({
  required BuildContext context,
}) =>
    showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      enableDrag: true,
      elevation: 20,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(top: getHeight(50)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: getWidth(100),
                height: getHeight(9),
                decoration: const BoxDecoration(
                    color: AppColors.secondryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
              ),
              SizedBox(
                height: getHeight(10),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(getWidth(15)),
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(),
                    title: Text("Name"),
                    subtitle: Text(
                        "commmmmmmmmmmmmmmmentcommmmmmmmmmmmmmmmentcommmmmmmmmmmmmmmmentcommmmmmmmmmmmmmmment"),
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: getHeight(10),
                  ),
                  itemCount: 20,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.primaryColor,
                        hintText: "Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: AppColors.primaryColor,
                      ))
                ],
              )
            ],
          ),
        );
      },
    );
