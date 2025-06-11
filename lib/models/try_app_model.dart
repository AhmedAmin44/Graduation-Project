// models/application_model.dart
class ApplicationDetails {
  final int applicationId;
  final String applicationName;
  final String createdDate;
  final String createdDepartment;
  final String notes;
  final String fileUrl;
  final List<HistoryItem> history;
  final List<ApplicationStep> steps;
  final String status;
  final String studentName;
  final String studentNId;
  final String applicationContext;

  ApplicationDetails({
    required this.applicationId,
    required this.applicationName,
    required this.createdDate,
    required this.createdDepartment,
    required this.notes,
    required this.fileUrl,
    required this.history,
    required this.steps,
    required this.status,
    required this.studentName,
    required this.studentNId,
    required this.applicationContext,
  });

  factory ApplicationDetails.fromJson(Map<String, dynamic> json) {
    return ApplicationDetails(
      applicationId: json['applicationId'],
      applicationName: json['applicationName'],
      createdDate: json['createdDate'],
      createdDepartment: json['createdDepartment'],
      notes: json['notes'],
      fileUrl: json['fileUrl'],
      history: List<HistoryItem>.from(
          json['history'].map((x) => HistoryItem.fromJson(x))),
      steps: _convertToApplicationSteps(json['steps']),
      status: json['statue'],
      studentName: json['studentName'],
      studentNId: json['studentNId'],
      applicationContext: json['applicationContext'],
    );
  }
   // Add this static conversion method
  static List<ApplicationStep> _convertToApplicationSteps(List<dynamic> stepsJson) {
    return stepsJson.map((step) {
      return ApplicationStep(
        departmentName: step['departmentName'],
        stepOrder: step['stepOrder'],
        isCompleted: step['isCompleted'],
        isCurrent: step['isCurrent'],
      );
    }).toList();
  }

}


class HistoryItem {
  final String inDate;
  final String outDate;
  final String action;
  final String department;
  final String notes;

  HistoryItem({
    required this.inDate,
    required this.outDate,
    required this.action,
    required this.department,
    required this.notes,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      inDate: json['inDate'],
      outDate: json['outDate'],
      action: json['action'],
      department: json['department'],
      notes: json['notes'],
    );
  }
}

class ApplicationStep {
  final String departmentName;
  final int stepOrder;
  final bool isCompleted;
  final bool isCurrent;

  ApplicationStep({
    required this.departmentName,
    required this.stepOrder,
    required this.isCompleted,
    required this.isCurrent,
  });

  factory ApplicationStep.fromJson(Map<String, dynamic> json) {
    return ApplicationStep(
      departmentName: json['departmentName'],
      stepOrder: json['stepOrder'],
      isCompleted: json['isCompleted'],
      isCurrent: json['isCurrent'],
    );
  }
}