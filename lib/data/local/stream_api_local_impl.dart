import 'package:fluchat/data/stream_api_repository.dart';
import 'package:fluchat/domain/models/chat_user.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamApiLocalImpl extends StreamApiRepository {
  StreamApiLocalImpl(this._client);

  final StreamChatClient _client;

  @override
  Future<ChatUser> connectUser(ChatUser user, String token) async {
    Map<String, dynamic> extraData = {};
    if (user.image != null) {
      extraData['image'] = user.image;
    }
    if (user.name != null) {
      extraData['name'] = user.name;
    }
    await _client.disconnectUser();
    await _client.connectUser(
      User(id: user.id, extraData: extraData),
      token,
    );
    return user;
  }

  @override
  Future<List<ChatUser>> getChatUsers() async {
    final result = await _client.queryUsers();
    final chatUsers = result.users
        .where((element) => element.id != _client.state.currentUser?.id)
        .map(
          (e) => ChatUser(
            id: e.id,
            name: e.name,
            image: e.extraData['image'] as String,
            email: e.extraData['email'] as String
          ),
        )
        .toList();
    return chatUsers;
  }

  @override
  Future<String> getToken(String userId) async {
    final token = await _client.devToken(userId);
    return token.rawValue;
  }

  @override
  Future<Channel> createGroupChat(String channelId, String name, List<String> members, {String? image}) async {
    final channel = _client.channel('messaging', id: channelId, extraData: {
      'name': name,
      'image': image,
      'members': [_client.state.currentUser?.id, ...members],
    });
    await channel.watch();
    return channel;
  }

  @override
  Future<Channel> createSimpleChat(String friendId) async {
    final channel =
        _client.channel('messaging', id: '${_client.state.currentUser?.id.hashCode}${friendId.hashCode}', extraData: {
      'members': [
        friendId,
        _client.state.currentUser?.id,
      ],
    });
    await channel.watch();
    return channel;
  }

  @override
  Future<void> logout() {
    return _client.disconnectUser();
  }

  @override
  Future<bool> connectIfExist(String userId) async {
    final token = await getToken(userId);
    await _client.connectUser(
      User(id: userId),
      token,
    );
    return _client.state.currentUser?.name != null && _client.state.currentUser?.name != userId;
  }
}
