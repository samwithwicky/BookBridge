class UserLocation {
  final String id;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String landmark;
  final bool isDefault;

  UserLocation({
    required this.id,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.landmark,
    this.isDefault = false,
  });

  // For easy updates
  UserLocation copyWith({
    String? id,
    String? address,
    String? city,
    String? state,
    String? postalCode,
    String? landmark,
    bool? isDefault,
  }) {
    return UserLocation(
      id: id ?? this.id,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  // Convert UserLocation object to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'landmark': landmark,
      'isDefault': isDefault,
    };
  }

  // Create a UserLocation object from a JSON Map
  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      id: json['id'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      landmark: json['landmark'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  // Helper method to get formatted full address
  String get formattedAddress {
    final buffer = StringBuffer();
    buffer.write(address);

    if (landmark.isNotEmpty) {
      buffer.write(', $landmark');
    }

    buffer.write('\n$city, $state $postalCode');

    return buffer.toString();
  }
}
