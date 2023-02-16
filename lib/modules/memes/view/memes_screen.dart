import 'package:flutter/material.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/modules/memes/view/widgets/memes_shape.dart';

class MemesScreen extends StatelessWidget {
  const MemesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Memes",style: TextStyle(
              fontSize: getFont(40),

      ),)),
      body: ListView.separated(
        padding: EdgeInsets.only(top: getHeight(10)),
        itemBuilder: (context, index) =>  
        const MemesShapeItem(),
        itemCount: 20,
        separatorBuilder: (context, index) => SizedBox(height: getHeight(7),),
        ),
      
    );
  }
}
