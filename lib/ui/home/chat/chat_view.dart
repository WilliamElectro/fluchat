import 'package:fluchat/ui/common/my_channel_preview.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 24,
            color: textColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
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
    );
  }
}

class ChannelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

class ChatDetailView extends StatelessWidget {
  const ChatDetailView({
    required Key key,
    this.image,
    this.name,
    this.channelId,
  }) : super(key: key);

  final String? image;
  final String? name;
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
