import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/api/dio_consumer.dart';
import 'package:graduation_app/core/widgets/customButton.dart';
import 'package:graduation_app/cubit/home_cubit.dart';
import 'package:graduation_app/cubit/home_states.dart';
import 'package:graduation_app/cubit/try_app_cubit.dart';
import 'package:graduation_app/models/sign_in_model.dart';
import 'package:graduation_app/models/student_application.dart';
import 'package:graduation_app/repositories/application_details_repository.dart';
import 'package:graduation_app/screens/profile_screen.dart';
import 'package:graduation_app/screens/request_status_screen.dart';
import 'package:graduation_app/screens/try_application_details_screen.dart';

class HomeView extends StatelessWidget {
  final String studentName;
  final String token;

  const HomeView({Key? key, required this.token, required this.studentName})
    : super(key: key);

  factory HomeView.fromRouteArguments(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return HomeView(
      token: args['token'] as String,
      studentName: args['studentName'] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ApplicationRepository(api: DioConsumer(dio: Dio()));

    return BlocProvider(
      create:
          (context) =>
              HomeCubit(repository, api: DioConsumer(dio: Dio()))
                ..fetchStudentApplications(token),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffFAFAFA), Colors.white70],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(child: BuildHomeContent(context)),
          ],
        ),
      ),
    );
  }

  Widget BuildHomeContent(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.purple),
          );
        } else if (state is HomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 20),
                CustomBotton(
                  onPressed:
                      () => context.read<HomeCubit>().fetchStudentApplications(
                        token,
                      ),
                  text: 'Retry',
                ),
              ],
            ),
          );
        } else if (state is HomeLoaded) {
          return ApplicationListWithSearch(
            applications: state.applications,
            studentName: studentName,
            token: token,
          );
        }
        return Container();
      },
    );
  }
}

class ApplicationListWithSearch extends StatefulWidget {
  final List<StudentApplication> applications;
  final String studentName;
  final String token;

  const ApplicationListWithSearch({
    Key? key,
    required this.applications,
    required this.studentName,
    required this.token,
  }) : super(key: key);

  @override
  State<ApplicationListWithSearch> createState() =>
      _ApplicationListWithSearchState();
}

class _ApplicationListWithSearchState extends State<ApplicationListWithSearch> {
  late TextEditingController _searchController;
  late List<StudentApplication> _filteredApplications;
  bool _showSearchField = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredApplications = widget.applications;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      final filtered =
          widget.applications.where((app) {
            final nameMatch = app.name.toLowerCase().contains(query);
            final idMatch = app.id.toString().contains(query);
            return nameMatch || idMatch;
          }).toList();

      setState(() {
        _filteredApplications = filtered;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  final fontSize = width * 0.04; 
                  final avatarRadius = width * 0.07;
                  final spacing = width * 0.03;

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing,
                      vertical: spacing,
                    ),
                    margin: EdgeInsets.only(bottom: spacing),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundImage: const AssetImage(
                            'assets/images/benha_logo.png',
                          ),
                        ),
                        SizedBox(width: spacing),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ProfileScreen(
                                      user: SignInModel.currentUser!,
                                    ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: const Color(0xffB6849F),
                            backgroundImage: const AssetImage(
                              'assets/images/profile_logo.png',
                            ),
                          ),
                        ),
                        SizedBox(width: spacing * 1.5),
                        Text(
                          'نظام رابط',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: EdgeInsets.only(left: spacing / 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              _showSearchField ? Icons.close : Icons.search,
                              color: const Color(0xffB6849F),
                              size: width * 0.06,
                            ),
                            onPressed: () {
                              setState(() {
                                _showSearchField = !_showSearchField;
                                if (!_showSearchField) {
                                  _searchController.clear();
                                  _filteredApplications = widget.applications;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 35),

              if (_showSearchField)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Text(
                        "Let's follow your requests.",
                        style: TextStyle(
                          color: const Color(0xff964F75),
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search requests...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: const Color(0xffB6849F),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 10),

              Text(
                "All requests :- ",
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: _filteredApplications.length,
                  itemBuilder: (context, index) {
                    final application = _filteredApplications[index];
                    return RequestCard(
                      token: widget.token,
                      reqestName: application.name,
                      id: application.id,
                      progressValue: application.progress,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RequestCard extends StatelessWidget {
  final int id;
  final String reqestName;
  final double progressValue;
  final String token;

  const RequestCard({
    required this.id,
    required this.reqestName,
    required this.progressValue,
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final fontSizeTitle = isMobile ? 14.0 : 16.0;
        final fontSizeValue = isMobile ? 12.0 : 15.0;

        return InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => ApplicationCubit(dio: Dio()),
                        child: RequestStatusScreen(
                          applicationId: id,
                          token: token,
                        ),
                      ),
                ),
              ),
          child: Card(
            color: const Color(0xffD8D8D8),
            margin: const EdgeInsets.all(9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRequestHeader(fontSizeTitle, fontSizeValue),
                  const SizedBox(height: 10),
                  _buildRequestId(fontSizeTitle, fontSizeValue),
                  const SizedBox(height: 20),
                  _buildProgressIndicator(progressValue),
                  const SizedBox(height: 20),
                  _buildDetailsButton(context, fontSizeTitle),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestHeader(double fontSizeTitle, double fontSizeValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Request Name:',
          style: TextStyle(
            fontSize: fontSizeTitle,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Flexible(
          child: Text(
            reqestName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSizeValue,
              color: const Color(0xff964F75),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestId(double fontSizeTitle, double fontSizeValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Request ID:',
          style: TextStyle(
            fontSize: fontSizeTitle,
            fontWeight: FontWeight.bold,
            color: const Color(0xffB6849F),
          ),
        ),
        Text(
          '$id',
          style: TextStyle(fontSize: fontSizeValue, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(double progressValue) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progressValue),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 14,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[200]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getGradientColor(value),
              ),
              minHeight: 14,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsButton(BuildContext context, double fontSize) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => ApplicationCubit(dio: Dio()),
                        child: ApplicationDetailsScreen(
                          applicationId: id,
                          token: token,
                        ),
                      ),
                ),
              ),
          child: Text(
            'More Details',
            style: TextStyle(
              fontSize: fontSize,
              color: const Color(0xff811F55),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _getGradientColor(double value) {
    if (value < 0.3) return Colors.redAccent;
    if (value < 0.7) return const Color.fromARGB(255, 148, 143, 101);
    return const Color.fromARGB(255, 74, 102, 92);
  }
}
