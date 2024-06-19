class UserProfile {
  final String name;
  final String phoneNumber;
  final int balance;
  final int inbalance;
  final int outbalance;
  final String formatted;

  UserProfile({
    required this.name,
    required this.phoneNumber,
    required this.balance,
    required this.inbalance,
    required this.outbalance,
    required this.formatted,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      balance: json['balance'] ?? 0,
      inbalance: json['inbalance'] ?? 0,
      outbalance: json['outbalance'] ?? 0,
      formatted: json['formatted'] ?? '',
    );
  }
}
