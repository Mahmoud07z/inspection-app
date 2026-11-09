import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/users/models/user.dart';
import 'package:inspection_app/features/users/services/user_service.dart';

final usersProvider =
    AsyncNotifierProvider<UsersNotifier, List<AppUser>>(UsersNotifier.new);

class UsersNotifier extends AsyncNotifier<List<AppUser>> {
  @override
  Future<List<AppUser>> build() => ref.read(userServiceProvider).getAll();

  Future<void> filterByRole(String? role) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(userServiceProvider).getAll(role: role));
  }

  Future<void> add(Map<String, dynamic> body) async {
    final user = await ref.read(userServiceProvider).create(body);
    state = AsyncData([...?state.valueOrNull, user]);
  }

  Future<void> updateItem(int id, Map<String, dynamic> body) async {
    final updated = await ref.read(userServiceProvider).update(id, body);
    state = AsyncData(state.valueOrNull
            ?.map((user) => user.id == id ? updated : user)
            .toList() ??
        [updated]);
  }

  Future<void> remove(int id) async {
    await ref.read(userServiceProvider).delete(id);
    state = AsyncData(state.valueOrNull?.where((u) => u.id != id).toList() ?? []);
  }
}
