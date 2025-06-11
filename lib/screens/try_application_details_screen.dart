import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/try_app_cubit.dart';
import 'package:graduation_app/widgets/try_time_line.dart';
import 'package:intl/intl.dart';

class ApplicationDetailsScreen extends StatelessWidget {
  final int applicationId;
  final String token;

  const ApplicationDetailsScreen({
    super.key,
    required this.applicationId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isSmall = width < 350;
    final isMedium = width < 450;

    double getFont(double base) =>
        isSmall
            ? base * 0.85
            : isMedium
            ? base * 0.95
            : base;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffFAFAFA), Colors.white70],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            BlocProvider(
              create:
                  (context) =>
                      ApplicationCubit(dio: Dio())
                        ..fetchApplicationDetails(applicationId, token),
              child: BlocBuilder<ApplicationCubit, ApplicationState>(
                builder: (context, state) {
                  if (state is ApplicationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ApplicationError) {
                    return Center(child: Text(state.message));
                  } else if (state is ApplicationLoaded) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 12 : 16,
                        vertical: isSmall ? 10 : 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: isSmall ? 20 : 40),
                          _buildHeaderRow(context, getFont, width),
                          SizedBox(height: isSmall ? 20 : 40),
                          Text(
                            'Request Flow ',
                            style: TextStyle(
                              fontSize: getFont(18),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: isSmall ? 25 : 20),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmall ? 10 : 25,
                            ),
                            child: ApplicationTimeline(
                              steps: state.applicationDetails.steps,
                            ),
                          ),
                          SizedBox(height: isSmall ? 40 : 100),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            endIndent: isSmall ? 8 : 20,
                            indent: isSmall ? 8 : 20,
                          ),
                          SizedBox(height: isSmall ? 10 : 20),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    double Function(double) getFont,
    double width,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                
                Icons.arrow_back_ios,
                color: Color(0xff811F55),
                size: 15,
                weight: 50,
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        SizedBox(width: width * 0.04),
        Expanded(
          child: Center(
            child: Text(
              ' Request Details',
              style: TextStyle(
                fontSize: getFont(20),
                fontWeight: FontWeight.bold,
                color: const Color(0xff811F55),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.history, color: Color(0xff811F55)),
          onPressed: () {
            final cubit = context.read<ApplicationCubit>();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: cubit,
                      child: HistoryScreen(getFont: getFont),
                    ),
              ),
            );
          },
        ),
      ],
    );
  }
}


class HistoryScreen extends StatelessWidget {
  final double Function(double) getFont;

  const HistoryScreen({super.key, required this.getFont});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 350;
    final state = context.watch<ApplicationCubit>().state;

    if (state is! ApplicationLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final history = state.applicationDetails.history;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffFAFAFA), Colors.white70],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: isSmall ? 20 : 40),
                Padding(
                  padding: EdgeInsets.all(isSmall ? 8 : 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
        
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xff811F55),
                              size: 15,
                              weight: 50,
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.1),
                      Text(
        
                        'History of Actions',
                        style: TextStyle(
                          fontSize: getFont(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff811F55),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(isSmall ? 8 : 16),
                    itemCount: history.length,
                    itemBuilder: (context, idx) {
                      final item = history[idx];
                      return Card(
                        color: const Color(0xffB6849F).withOpacity(0.5),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: isSmall ? 4 : 10,
                          vertical: isSmall ? 4 : 10,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmall ? 8 : 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' Department : ${item.department}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getFont(16),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: isSmall ? 4 : 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmall ? 4 : 8,
                                  vertical: isSmall ? 2 : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffD9D9D9).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blueGrey.withOpacity(0.3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  item.action,
                                  style: TextStyle(
                                    fontSize: getFont(16),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmall ? 4 : 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.parse(item.inDate)),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: getFont(14),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isSmall ? 2 : 4),
                              if (item.notes.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Details : ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: getFont(16),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      ' ${item.notes}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: getFont(16),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
