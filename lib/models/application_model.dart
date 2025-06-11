// application_status_model.dart

class ApplicationStatus {
  final String status;
  final List<ApplicationStep> steps;

  ApplicationStatus({
    required this.status,
    required this.steps,
  });

  factory ApplicationStatus.fromJson(Map<String, dynamic> json) {
    return ApplicationStatus(
      status: json['statue'],
      steps: List<ApplicationStep>.from(
        json['steps'].map((x) => ApplicationStep.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'statue': status,
        'steps': List<dynamic>.from(steps.map((x) => x.toJson())),
      };
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

  Map<String, dynamic> toJson() => {
        'departmentName': departmentName,
        'stepOrder': stepOrder,
        'isCompleted': isCompleted,
        'isCurrent': isCurrent,
      };
}