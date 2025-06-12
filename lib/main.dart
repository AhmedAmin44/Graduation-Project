import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cache/cache_helper.dart';
import 'package:graduation_app/core/api/dio_consumer.dart';
import 'package:graduation_app/cubit/user_cubit.dart';
import 'package:graduation_app/repositories/user_repository.dart';
import 'package:graduation_app/screens/on_boarding_screen.dart';
import 'package:graduation_app/screens/splash_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await CacheHelper().init();
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());
  runApp(
    BlocProvider(
      create:
          (context) => UserCubit(UserRepository(api: DioConsumer(dio: Dio()))),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
