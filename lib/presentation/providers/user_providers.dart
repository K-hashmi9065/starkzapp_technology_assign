import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote_user_api.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

final remoteApiProvider = Provider<RemoteUserApi>((ref) => RemoteUserApi());

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(remoteApiProvider);
  return UserRepositoryImpl(api);
});

class UsersState {
  final List<UserProfile> users;
  final bool isLoading;
  final Object? error;
  const UsersState({this.users = const [], this.isLoading = false, this.error});

  UsersState copyWith({
    List<UserProfile>? users,
    bool? isLoading,
    Object? error,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UsersNotifier extends StateNotifier<UsersState> {
  final UserRepository repository;
  UsersNotifier(this.repository) : super(const UsersState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await repository.fetchUsers(results: 20);
      state = state.copyWith(users: data, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void toggleLike(String id) {
    final updated = state.users
        .map((u) => u.id == id ? u.copyWith(liked: !u.liked) : u)
        .toList();
    state = state.copyWith(users: updated);
  }

  UserProfile? byId(String id) {
    try {
      return state.users.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UsersNotifier(repo);
});
