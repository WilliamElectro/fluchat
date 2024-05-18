import 'package:fluchat/domain/usecases/backend_logic.dart';
import 'package:fluchat/ui/common/my_channel_preview.dart';
import 'package:fluchat/utils/GlobalVariables.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:fluchat/ui/home/chat/selection/friends_selection_view.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).appBarTheme.backgroundColor;

    // Crea una instancia de StreamChannelListController
    final channelListController = StreamChannelListController(
      client: StreamChat.of(context).client,
      filter: Filter.in_(
        'members',
        [StreamChat.of(context).currentUser!.id],
      ),
      channelStateSort: const [SortOption('last_message_at')],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: RefreshIndicator(
        onRefresh: channelListController.refresh,
        child: StreamChannelListView(
          controller: channelListController,
          onChannelTap: (channel) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamChannel(
                channel: channel,
                child: ChannelPage(),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendsSelectionView()),
          );
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _handleMemberLogic(context);
    return Scaffold(
      appBar: StreamChannelHeader(),
      body: Column(
        children: [
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}

void _handleMemberLogic(BuildContext context) {
  final channel = StreamChannel.of(context).channel;
  final memberCount = channel.memberCount;
  final List<Member>? members = channel.state?.members;

  if (memberCount != null && memberCount == 2) {
    final userId = StreamChat.of(context).currentUser?.id;
    final otherMember =
        members?.firstWhere((member) => member.user?.id != userId);
    final email = otherMember?.user?.extraData['email'];

    String emailDestinatary = (email is String) ? email : '';
    GlobalVariables.isWorkerAvailable =
        BackendLogic().isWorkerAvailable(emailDestinatary);
  }
}

class ChatDetailView extends StatelessWidget {
  const ChatDetailView({
    required Key key,
    this.image,
    this.name,
    this.email,
    this.channelId,
  }) : super(key: key);

  final String? image;
  final String? name;
  final String? email;
  final String? channelId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: Material(
        color: Colors.transparent,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: channelId!,
                  child: ClipOval(
                    child: Image.network(
                      image!,
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  name!,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
