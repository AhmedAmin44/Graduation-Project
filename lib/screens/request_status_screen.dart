import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/widgets/customButton.dart';
import 'package:graduation_app/cubit/try_app_cubit.dart';

class RequestStatusScreen extends StatelessWidget {
  final int applicationId;
  final String token;

  const RequestStatusScreen({
    super.key,
    required this.applicationId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            ApplicationCubit(dio: Dio())..fetchApplicationDetails(applicationId, token),
        child: BlocBuilder<ApplicationCubit, ApplicationState>(
          builder: (context, state) {
            if (state is ApplicationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ApplicationError) {
              return Center(child: Text(state.message));
            } else if (state is ApplicationLoaded) {
              final details = state.applicationDetails;

              switch (details.status) {
                case 'مقبول':
                  return _StatusScreen(
                    image: 'assets/images/success.png',
                    iconColor: Colors.green,
                    bgColor: Colors.green.shade50,
                    reqName: ' ${details.applicationName}',
                    applicationId: details.applicationId,
                    title: 'Your request has been accepted.',
                    message:
                        'Thank you for your application!\nYour document is ready for collection.\nNow you can call the university to confirm it and know your next steps.',
                  );
                case 'قيد_التنفيذ':
                  return _StatusScreen(
                    image: 'assets/images/waiting.png',
                    iconColor: Colors.orange,
                    bgColor: Colors.orange.shade50,
                    reqName: 'الطلب قيد الانتظار: ${details.applicationName}',
                    applicationId: details.applicationId,
                    title: 'Your document is on the waiting list for processing.',
                    message:
                        'We’ll notify you when it’s ready.\nThis usually takes about 3 - 5 business days.',
                  );
                case 'مرفوض':
                default:
                  return _StatusScreen(
                    image: 'assets/images/fail.png',
                    iconColor: Colors.red,
                    bgColor: Colors.red.shade50,
                    reqName: 'رفض الطلب: ${details.applicationName}',
                    applicationId: details.applicationId,
                    title: 'We are sorry,\nbut your request has been rejected.',
                    message:
                        'Please contact support for more information\nor visit our website to know more.',
                  );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _StatusScreen extends StatelessWidget {
  final String image;
  final Color iconColor;
  final Color bgColor;
  final String reqName;
  final int applicationId;
  final String title;
  final String message;

  const _StatusScreen({
    required this.image,
    required this.iconColor,
    required this.bgColor,
    required this.reqName,
    required this.applicationId,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.04,
        ).copyWith(top: screenHeight * 0.1),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  image,
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.25,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: screenHeight * 0.03),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.01),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              CustomBotton(
                text: 'Got it',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
