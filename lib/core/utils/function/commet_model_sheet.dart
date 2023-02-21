import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:havefun/core/utils/app_assets.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/function/app_toast.dart';
import 'package:havefun/core/utils/function/need_login_model_sheet.dart';
import 'package:havefun/core/utils/function/shared_prefrance_utils.dart';
import 'package:havefun/core/utils/shared_preferance_const.dart';
import 'package:havefun/core/widgets/empty.dart';
import 'package:havefun/core/widgets/loading_item.dart';

import '../size_config.dart';

showSheet({required BuildContext context, required String memesDocId}) async {
  final commentController = TextEditingController();
  return showBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    enableDrag: true,
    elevation: 0,
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: getHeight(50)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
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
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("memes")
                    .doc(memesDocId)
                    .collection("comment")
                    .orderBy("added_at")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isEmpty
                        ? Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    EmptyShape(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.all(getWidth(15)),
                              itemBuilder: (context, index) => ListTile(
                                leading: CircleAvatar(
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.docs[index]
                                            .get("user_image"),
                                        progressIndicatorBuilder: (context, url,
                                                progress) =>
                                            const LoadingItem(),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: Image.asset(
                                                    AppAssets.splashImg))),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]
                                          .get("user_name"),
                                      style: TextStyle(
                                          fontSize: getFont(25),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    Text(
                                      (snapshot.data!.docs[index]
                                              .get("added_at") as Timestamp)
                                          .toDate()
                                          .toString()
                                          .split(" ")[0],
                                      style: TextStyle(
                                          fontSize: getFont(19),
                                          color: AppColors.secondryColor
                                              .withOpacity(.7)),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  snapshot.data!.docs[index].get("comment"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: getFont(22)),
                                ),
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                height: getHeight(10),
                              ),
                              itemCount: snapshot.data!.docs.length,
                            ),
                          );
                  } else if (snapshot.hasError) {
                    return const Center(
                        child:
                            Text("Something Went wrong, Check your network!"));
                  } else {
                    return const LoadingItem();
                  }
                }),
            Padding(
              padding: EdgeInsets.all(getWidth(7)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
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
                      onPressed: () {
                        if (PreferenceUtils.getString(
                                SharedPreferencesConst.uid)
                            .isEmpty) {
                          Navigator.pop(context);
                          needLogin(context: context);
                        } else {
                          if (commentController.text.trim().isNotEmpty) {
                            try {
                              FirebaseFirestore.instance
                                  .collection("memes")
                                  .doc(memesDocId)
                                  .collection("comment")
                                  .add({
                                "user_image": PreferenceUtils.getString(
                                  SharedPreferencesConst.image,
                                ),
                                "user_name": PreferenceUtils.getString(
                                  SharedPreferencesConst.name,
                                ),
                                "user_auth_id": PreferenceUtils.getString(
                                  SharedPreferencesConst.uid,
                                ),
                                "user_doc_id": PreferenceUtils.getString(
                                  SharedPreferencesConst.docId,
                                ),
                                "comment": commentController.text.trim(),
                                "added_at": DateTime.now()
                              }).then((value) {
                                commentController.clear();
                              }).onError<FirebaseException>(
                                      (error, stackTrace) {
                                debugPrint(error.toString());

                                appToast(
                                    msg:
                                        "Something went wrong, please try again!");
                              });
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.primaryColor,
                      ))
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
