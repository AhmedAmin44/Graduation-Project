class OnBoardingModel {
  final String imagePath;
  final String title;
  final String subTitle;
  OnBoardingModel({
    required this.imagePath,
    required this.title,
    required this.subTitle,
  });
}

List<OnBoardingModel> onBoardingData = [
  OnBoardingModel(
    imagePath: 'assets/images/Paperwork_vector.png',
    title: "Overwhelming Paperwork and High Costs",
    subTitle:
        "Traditional paper-based systems caused massive stress, high expenses, scattered documents, and significant time waste.",
  ),
  OnBoardingModel(
    imagePath: 'assets/images/Woman_stressed_in_workplace.png',
    title: "Unanswered Questions and No Support",
    subTitle:
        "Employees were overwhelmed with inquiries and lacked digital tools or systems to assist them, leading to delays and inefficiencies.",
  ),
  OnBoardingModel(
    imagePath: 'assets/images/timeline_infographic.png',
    title: "Your Smart Academic Assistant",
    subTitle:
        "Designed for students, helps you track your requests, understand every detail, and solve previous challenges—efficiently and clearly.",
  ),
];
