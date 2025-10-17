import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<List<UserProfile>> fetchUsers({int results});
}


