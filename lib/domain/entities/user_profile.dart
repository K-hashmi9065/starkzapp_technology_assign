class UserProfile {
  final String id; // uuid from api
  final String firstName;
  final String city;
  final int age;
  final String imageLargeUrl;
  final String imageMediumUrl;
  final String imageThumbnailUrl;
  final bool liked;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.city,
    required this.age,
    required this.imageLargeUrl,
    required this.imageMediumUrl,
    required this.imageThumbnailUrl,
    this.liked = false,
  });

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? city,
    int? age,
    String? imageLargeUrl,
    String? imageMediumUrl,
    String? imageThumbnailUrl,
    bool? liked,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      city: city ?? this.city,
      age: age ?? this.age,
      imageLargeUrl: imageLargeUrl ?? this.imageLargeUrl,
      imageMediumUrl: imageMediumUrl ?? this.imageMediumUrl,
      imageThumbnailUrl: imageThumbnailUrl ?? this.imageThumbnailUrl,
      liked: liked ?? this.liked,
    );
  }
}
