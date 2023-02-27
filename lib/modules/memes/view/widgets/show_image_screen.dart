import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
 
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/loading_item.dart';

class ShowImageScreen extends StatelessWidget {
  final String memesImg;
  const ShowImageScreen({super.key, required this.memesImg});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,),
        body: InteractiveViewer(
          minScale: 5,
          maxScale: 15,
          child: Center(
            
            child: CachedNetworkImage(  
              width: double.infinity,
                fit: BoxFit.fill,
                imageUrl: memesImg,
                progressIndicatorBuilder: (context, url, progress) =>
                    SizedBox(height: getHeight(250), child: const LoadingItem()),
                errorWidget: (context, url, error) => const Center(
                    child: Text("Something went wrong, Check your network!"))),
          ),
        ),
      ),
    );
  }
}
