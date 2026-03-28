class Experience {
  final String company;
  final String role;
  final String period;
  final String description;

  const Experience({
    required this.company,
    required this.role,
    required this.period,
    required this.description,
  });
}

class Project {
  final String number;
  final String title;
  final String description;
  final List<String> tags;
  final String linkLabel;
  final String? url;

  const Project({
    required this.number,
    required this.title,
    required this.description,
    required this.tags,
    required this.linkLabel,
    this.url,
  });
}

class Skill {
  final String name;
  final double percentage;

  const Skill({required this.name, required this.percentage});
}

class PortfolioData {
  static const List<String> techStack = [
    'Flutter', 'Dart', 'Firebase', 'Provider',
    'Riverpod', 'REST APIs', 'SQLite', 'Razorpay',
    'Agora SDK', 'Google Maps', 'JWT Auth', 'Git & GitHub',
  ];

  static const List<Experience> experiences = [
    Experience(
      company: 'Weblord Infotech',
      role: 'Flutter Developer',
      period: 'Jan 2024 — Present',
      description:
          'Architected and developed cross-platform mobile applications using Flutter and Provider state management. Integrated Firebase services and RESTful APIs to deliver seamless user experiences.',
    ),
    Experience(
      company: 'Hindtech IT Solution',
      role: 'Flutter Developer',
      period: 'Mar 2023 — Jan 2024',
      description:
          'Developed 5+ production-ready mobile apps with SQLite integration. Optimized performance achieving 30% faster loading times and significantly improved user retention rates.',
    ),
    Experience(
      company: 'Papaya Coders Pvt. Ltd',
      role: 'Junior Flutter Developer',
      period: 'Earlier',
      description:
          'Assisted in app development and learned the Flutter framework fundamentals in a professional mobile development environment.',
    ),
  ];

  static const List<Project> projects = [
    Project(
      number: '01',
      title: 'Pujari Ji',
      description:
          'A comprehensive spiritual services platform offering online/offline Pooja bookings, astrology consultations, Kundali analysis, and temple services with video calling.',
      tags: ['Flutter', 'Firebase', 'Razorpay', 'Agora SDK', 'Google Maps'],
      linkLabel: 'Live on Play Store',
    ),
    Project(
      number: '02',
      title: 'Day 2 Day Post',
      description:
          'Creative design app for business branding with 500+ professional templates, drag-and-drop interface, real-time filters, HD export, and social media sharing.',
      tags: ['Flutter', 'CustomPainter', 'Image Processing', 'UI/UX'],
      linkLabel: 'Live on Play Store',
    ),
    Project(
      number: '03',
      title: 'HRMS',
      description:
          'Enterprise-grade HR solution with biometric attendance geo-fencing, automated payroll processing, JWT authentication, and role-based access control.',
      tags: ['Flutter', 'JWT Auth', 'Geolocation', 'Payroll Logic'],
      linkLabel: 'Live on Play Store',
    ),
    Project(
      number: '04',
      title: 'Housing Magic CP',
      description:
          'Real estate marketplace with smart search filters, Google Maps integration, interactive microsites for property visibility, and personalized lead management.',
      tags: ['Flutter', 'Real Estate API', 'Google Maps'],
      linkLabel: 'Live on Play Store',
    ),
    Project(
      number: '05',
      title: 'Global Job MG',
      description:
          'International recruitment platform with application tracking, candidate profile management, resume builder, and interview scheduling for overseas placements.',
      tags: ['Flutter', 'REST API', 'Job Management'],
      linkLabel: 'Live on Play Store',
    ),
    Project(
      number: '06',
      title: 'As Pujari Ji',
      description:
          'B2B vendor portal designed for priests and astrologers to manage bookings and connect with clients efficiently via Firebase Auth.',
      tags: ['Flutter', 'Provider', 'Firebase Auth'],
      linkLabel: 'B2B Portal',
    ),
  ];

  static const List<Skill> coreSkills = [
    Skill(name: 'Flutter & Dart', percentage: 0.95),
    Skill(name: 'Firebase Services', percentage: 0.88),
    Skill(name: 'Provider / Riverpod', percentage: 0.85),
    Skill(name: 'REST APIs', percentage: 0.90),
  ];

  static const List<Skill> additionalSkills = [
    Skill(name: 'SQLite & Local Storage', percentage: 0.82),
    Skill(name: 'Google Maps API', percentage: 0.80),
    Skill(name: 'UI/UX Design', percentage: 0.78),
    Skill(name: 'Git & GitHub', percentage: 0.85),
  ];
}
