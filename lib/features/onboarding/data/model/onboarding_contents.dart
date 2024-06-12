import '../../../../core/utils/assets.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to OpenCV Face \nRecognition",
    image: Assets.onboarding1,
    desc: "Experience the ready-to-use OpenCV Face \nRecognition App, powered by Seventh Sense \nwith its world-class technology.",
  ),
  OnboardingContents(
    title: "Effortless Face Enrolment & \nIdentification",
    image: Assets.onboarding2,
    desc: "Enrolling or identifying faces is as simple as \ntaking a photo.",
  ),
  OnboardingContents(
    title: "Accurate Face Comparison (1:1)",
    image: Assets.onboarding3,
    desc: "We offer instant and highly accurate face \ncompare and verification (1:1).",
  ),
    OnboardingContents(
    title: "Seamless Integration Across a \nUnified Platform",
    image: Assets.onboarding4,
    desc: "Enjoy an all-in-one solution that syncs your \ndata and account across Mobile Apps, APIs/\nSDKs, and the Web Developer Portal.",
  ),
];
