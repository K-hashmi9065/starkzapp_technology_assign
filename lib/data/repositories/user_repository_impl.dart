import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote_user_api.dart';
import 'package:flutter/foundation.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteUserApi api;
  UserRepositoryImpl(this.api);

  @override
  Future<List<UserProfile>> fetchUsers({int results = 20}) async {
    final dtos = await api.getUsers(results: results);
    return dtos
        .map(
          (d) => UserProfile(
            id: d.id,
            firstName: d.firstName,
            city: d.city,
            age: d.age,
            imageLargeUrl: _webSafeImageUrl(d.imageLargeUrl),
            imageMediumUrl: _webSafeImageUrl(d.imageMediumUrl),
            imageThumbnailUrl: _webSafeImageUrl(d.imageThumbnailUrl),
          ),
        )
        .toList();
  }
}

String _webSafeImageUrl(String url) {
  if (!kIsWeb) return url;
  final cleaned = url.replaceFirst(RegExp(r'^https?://'), '');
  return 'https://images.weserv.nl/?url=ssl:$cleaned';
}
