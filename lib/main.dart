import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'core/utils/app_string.dart';
import 'core/utils/function/shared_prefrance_utils.dart';
import 'modules/splash_screen/view/splash_screen.dart';
import 'modules/upload/controller/upload_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferenceUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UploadCubit(),
        ),
      ],
      child: MaterialApp(
        title: AppString.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              titleTextStyle: TextStyle(
                fontFamily: "head",
              )),
          brightness: Brightness.dark,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
