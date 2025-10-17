class UserDto {
  final String id;
  final String firstName;
  final String city;
  final int age;
  final String imageLargeUrl;
  final String imageMediumUrl;
  final String imageThumbnailUrl;

  const UserDto({
    required this.id,
    required this.firstName,
    required this.city,
    required this.age,
    required this.imageLargeUrl,
    required this.imageMediumUrl,
    required this.imageThumbnailUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    String large = json['picture']?['large'] ?? '';
    String medium = json['picture']?['medium'] ?? json['picture']?['med'] ?? '';
    String thumb =
        json['picture']?['thumbnail'] ?? json['picture']?['thumb'] ?? '';
    if (large.startsWith('http://')) {
      large = large.replaceFirst('http://', 'https://');
    }
    if (medium.startsWith('http://')) {
      medium = medium.replaceFirst('http://', 'https://');
    }
    if (thumb.startsWith('http://')) {
      thumb = thumb.replaceFirst('http://', 'https://');
    }
    return UserDto(
      id: json['login']?['uuid'] ?? '',
      firstName: json['name']?['first'] ?? '',
      city: json['location']?['city'] ?? '',
      age: (json['dob']?['age'] ?? 0) as int,
      imageLargeUrl: large,
      imageMediumUrl: medium,
      imageThumbnailUrl: thumb,
    );
  }
}
