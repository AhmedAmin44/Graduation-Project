import 'package:flutter/material.dart';
import 'package:graduation_app/models/try_app_model.dart';

class ApplicationTimeline extends StatelessWidget {
  final List<ApplicationStep> steps;

  const ApplicationTimeline({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return TimelineStepItem(
          step: step,
          isFirst: index == 0,
          isLast: index == steps.length - 1,
          index: index,
          totalSteps: steps.length,
        );
      },
    );
  }
}

class TimelineStepItem extends StatelessWidget {
  final ApplicationStep step;
  final bool isFirst;
  final bool isLast;
  final int index;
  final int totalSteps;

  const TimelineStepItem({
    Key? key,
    required this.step,
    required this.isFirst,
    required this.isLast,
    required this.index,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: _getLineColor(index - 1),
                ),
              Container(
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.isCompleted ? const Color(0xffB6849F) : Colors.grey[300],
                  boxShadow: step.isCompleted
                      ? [
                          BoxShadow(
                            color: const Color(0xffB6849F).withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: step.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Center(
                        child: Container(
                          width: screenWidth * 0.03,
                          height: screenWidth * 0.03,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffB6849F).withOpacity(0.5),
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: _getLineColor(index),
                ),
              ),
            ],
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 24,
                top: isFirst ? 0 : 8,
              ),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: step.isCompleted 
                    ? const Color(0xffB6849F).withOpacity(0.3)
                    : Colors.grey.withOpacity(0.05),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenWidth * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: step.isCompleted
                                  ? const Color(0xffD9D9D9)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Step ${index + 1}',
                              style: TextStyle(
                                color: step.isCompleted
                                    ? Colors.black
                                    : Colors.grey[800],
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            step.departmentName,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: step.isCompleted
                                  ? Colors.white
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      Text(
                        step.isCompleted ? 'تم الانتهاء' : 'في انتظار المراجعة',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: step.isCompleted
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLineColor(int stepIndex) {
    if (stepIndex < index) {
      return const Color(0xffD9D9D9);
    } else if (stepIndex == index && step.isCompleted) {
      return const Color(0xffB6849F).withOpacity(0.5);
    }
    return Colors.grey[300]!;
  }
}
