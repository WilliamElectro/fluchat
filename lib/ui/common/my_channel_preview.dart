import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Modify it to change the widget appearance.
class MyChannelPreview extends StatelessWidget {
  /// Function called when tapping this widget
  final void Function(Channel)? onTap;

  /// Function called when long pressing this widget
  final void Function(Channel)? onLongPress;

  /// Channel displayed
  final Channel channel;

  /// The function called when the image is tapped
  final VoidCallback? onImageTap;

  final String? heroTag;

  MyChannelPreview({
    required this.channel,
    Key? key,
    this.onTap,
    this.onLongPress,
    this.onImageTap,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: channel.isMutedStream,
        initialData: channel.isMuted,
        builder: (context, snapshot) {
          final isMuted = snapshot.data ??
              false; // Proporciona un valor por defecto de 'false'.
          return Opacity(
            opacity: isMuted ? 0.5 : 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              onTap: () {
                if (onTap != null) {
                  onTap!(channel);
                }
              },
              onLongPress: () {
                if (onLongPress != null) {
                  onLongPress!(channel);
                }
              },
              leading: Material(
                child: Hero(
                  tag: heroTag!,
                  child: StreamChannel(
                    channel: channel,
                    //child: Container(),
                    child: InkWell(
                      onTap: onImageTap,
                    ),
                    //child: ChannelImage(
                    //  onTap: onImageTap,
                    //),
                    //child: Ink.image(
                    //  image: onImageTap,
                    //),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: ChannelName(
                      textStyle: StreamChatTheme.of(context)
                          .channelPreviewTheme
                          .titleStyle,
                    ),
                  ),
                  StreamBuilder<List<Member>>(
                      stream: channel.state?.membersStream,
                      initialData: channel.state?.members,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data!.isEmpty ||
                            !snapshot.data!.any((Member e) =>
                                e.user?.id ==
                                channel.client.state.currentUser?.id)) {
                          return SizedBox();
                        }
                        return ChannelUnreadIndicator(
                          channel: channel,
                          key: null,
                        );
                      }),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child: _buildSubtitle(context)),
                  Builder(
                    builder: (context) {
                      final lastMessage = channel.state?.messages.lastWhere(
                        (m) => !m.isDeleted && m.shadowed != true,
                        orElse: () => Message(),
                      );
                      if (lastMessage != null &&
                          lastMessage.user?.id ==
                              StreamChat.of(context).currentUser?.id) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: StreamSendingIndicator(
                            message: lastMessage,
                            size: StreamChatTheme.of(context)
                                .channelPreviewTheme
                                .indicatorIconSize,
                            isMessageRead: channel.state?.read
                                    ?.where((element) =>
                                        element.user.id !=
                                        channel.client.state.currentUser?.id)
                                    ?.where((element) => element.lastRead
                                        .isAfter(lastMessage.createdAt))
                                    ?.isNotEmpty ==
                                true,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  _buildDate(context),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildDate(BuildContext context) {
    return StreamBuilder<DateTime?>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }
        final lastMessageAt = snapshot.data?.toLocal();

        String stringDate = 'No date available';
        final now = DateTime.now();

        var startOfDay = DateTime(now.year, now.month, now.day);
        if (lastMessageAt != null) {
          if (lastMessageAt.millisecondsSinceEpoch >=
              startOfDay.millisecondsSinceEpoch) {
            stringDate = Jiffy.parseFromDateTime(lastMessageAt.toLocal()).Hm;
          } else if (lastMessageAt.millisecondsSinceEpoch >=
              startOfDay.subtract(Duration(days: 1)).millisecondsSinceEpoch) {
            stringDate = 'Yesterday';
          } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
            stringDate = Jiffy.parseFromDateTime(lastMessageAt.toLocal()).EEEE;
          } else {
            stringDate = Jiffy.parseFromDateTime(lastMessageAt.toLocal()).yMd;
          }
        }

        return Text(
          stringDate,
          style: StreamChatTheme.of(context)
              .channelPreviewTheme
              .lastMessageAtStyle,
        );
      },
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    if (channel.isMuted) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          StreamSvgIcon.mute(
            size: 16,
          ),
          Text(
            '  Channel is muted',
            style: StreamChatTheme.of(context)
                .channelPreviewTheme
                .subtitleStyle
                ?.copyWith(
                  color: StreamChatTheme.of(context)
                      .channelPreviewTheme
                      .subtitleStyle
                      ?.color,
                ),
          ),
        ],
      );
    }
    return StreamTypingIndicator(
      channel: channel,
      alternativeWidget: _buildLastMessage(context),
      style: StreamChatTheme.of(context)
          .channelPreviewTheme
          .subtitleStyle
          ?.copyWith(
            color: StreamChatTheme.of(context)
                .channelPreviewTheme
                .subtitleStyle
                ?.color,
          ),
    );
  }

  Widget _buildLastMessage(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: channel.state?.messagesStream,
      initialData: channel.state?.messages,
      builder: (context, snapshot) {
        final lastMessage = snapshot.data?.lastWhere(
            (m) => m.shadowed != true && !m.isDeleted,
            orElse: () => Message());
        if (lastMessage == null) {
          return SizedBox();
        }

        var text = lastMessage.text;
        if (lastMessage.attachments != null) {
          final parts = <String>[
            ...lastMessage.attachments.map((e) {
              if (e.type == 'image') {
                return '📷';
              } else if (e.type == 'video') {
                return '🎬';
              } else if (e.type == 'giphy') {
                return '[GIF]';
              }
              return e == lastMessage.attachments.last
                  ? (e.title ?? 'File')
                  : '${e.title ?? 'File'} , ';
            }).where((e) => e != null),
            lastMessage.text ?? '',
          ];

          text = parts.join(' ');
        }

        return Text.rich(
          _getDisplayText(
            text!,
            lastMessage.mentionedUsers,
            lastMessage.attachments,
            StreamChatTheme.of(context)
                .channelPreviewTheme
                .subtitleStyle!
                .copyWith(
                    color:
                        StreamChatTheme.of(context)
                            .channelPreviewTheme
                            .subtitleStyle
                            ?.backgroundColor,
                    fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                        ? FontStyle.italic
                        : FontStyle.normal),
            StreamChatTheme.of(context)
                .channelPreviewTheme
                .subtitleStyle!
                .copyWith(
                    color:
                        StreamChatTheme.of(context)
                            .channelPreviewTheme
                            .subtitleStyle
                            ?.backgroundColor,
                    fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontWeight: FontWeight.bold),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  TextSpan _getDisplayText(
      String text,
      List<User> mentions,
      List<Attachment> attachments,
      TextStyle normalTextStyle,
      TextStyle mentionsTextStyle) {
    var textList = text.split(' ');
    var resList = <TextSpan>[];
    for (var e in textList) {
      if (mentions != null &&
          mentions.isNotEmpty &&
          mentions.any((element) => '@${element.name}' == e)) {
        resList.add(TextSpan(
          text: '$e ',
          style: mentionsTextStyle,
        ));
      } else if (attachments != null &&
          attachments.isNotEmpty &&
          attachments
              .where((e) => e.title != null)
              .any((element) => element.title == e)) {
        resList.add(TextSpan(
          text: '$e ',
          style: normalTextStyle.copyWith(fontStyle: FontStyle.italic),
        ));
      } else {
        resList.add(TextSpan(
          text: e == textList.last ? '$e' : '$e ',
          style: normalTextStyle,
        ));
      }
    }

    return TextSpan(children: resList);
  }
}

class ChannelUnreadIndicator extends StatelessWidget {
  const ChannelUnreadIndicator({
    Key? key,
    required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: channel.state?.unreadCountStream,
      initialData: channel.state?.unreadCount,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == 0) {
          return SizedBox();
        }

        return Material(
          borderRadius: BorderRadius.circular(8),
          color: StreamChatTheme.of(context)
              .channelPreviewTheme
              .unreadCounterColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              top: 2,
              bottom: 1,
            ),
            child: Center(
              child: Text(
                '${snapshot.data! > 99 ? '99+' : snapshot.data}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
