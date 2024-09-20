import 'package:faker/faker.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../constants.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final channelListController = StreamChannelListController(
      client: StreamChatCore.of(context).client,
      filter: Filter.and([
        Filter.equal('type', 'messaging'),
        Filter.in_('members', [StreamChatCore.of(context).currentUser!.id]),
      ]));
  @override
  void initState() {
    channelListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    channelListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedValueListenableBuilder<int, Channel>(
      valueListenable: channelListController,
      builder: (context, value, child) {
        return value.when(
          (channels, nextPageKey, error) => LazyLoadScrollView(
            onEndOfPage: () async {
              if (nextPageKey != null) {
                channelListController.loadMore(nextPageKey);
              }
            },
            child: channels.isNotEmpty
                ? CustomScrollView(slivers: [
                    const SliverToBoxAdapter(
                      child: _Story(),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return _MessageCard(
                          channel: channels[index],
                        );
                      },
                          childCount: (nextPageKey != null || error != null)
                              ? channels.length + 1
                              : channels.length),
                    )
                  ])
                : const Center(
                    child: Text('No messages yet, start a new conversation!'),
                  ),
          ),
          loading: () => const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e) => Center(
            child: Text(
              'Oh no, something went wrong. '
              'Please check your config. $e',
            ),
          ),
        );
      },
    );

    // return CustomScrollView(slivers: [
    //   const SliverToBoxAdapter(
    //     child: _Story(),
    //   ),
    //   SliverList(delegate: SliverChildBuilderDelegate((context, index) {
    //     DateTime date = randomDate();
    //     return _MessageCard(
    //       messageData: MessageData(
    //         name: faker.person.name(),
    //         message: faker.lorem.sentence(),
    //         profilePicture: randomImageUrl(),
    //         messageDate: date,
    //         dateMessage: Jiffy.parseFromDateTime(date).fromNow(),
    //       ),
    //     );
    //   }))
    // ]);
  }
}

class _MessageCard extends StatefulWidget {
  const _MessageCard({required this.channel});
  final Channel channel;
  @override
  State<_MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<_MessageCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/chat', arguments: widget.channel);
      },
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Avatar.medium(
                      imageUrl: getChannelImage(widget.channel, context.user!)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getChannelName(widget.channel, context.user!),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).primaryColorDark),
                        overflow: TextOverflow.ellipsis,
                      ),

                      // const SizedBox(height: 4),
                      const SizedBox(
                        height: 4.0,
                      ),
                      SizedBox(
                        height: 20.0,
                        child: _getLastMessage(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 14.0, bottom: 14.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _getLastMessageAt(),
                      const SizedBox(
                        height: 8.0,
                      ),
                      _getUnreadCount(),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Theme.of(context).disabledColor,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getLastMessage() {
    return BetterStreamBuilder<Message>(
      stream: widget.channel.state!.lastMessageStream,
      initialData: widget.channel.state!.lastMessage,
      builder: (context, lastMessage) {
        return Text(
          lastMessage.text ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _getLastMessageAt() {
    return BetterStreamBuilder<DateTime>(
      stream: widget.channel.lastMessageAtStream,
      initialData: widget.channel.lastMessageAt,
      builder: (context, data) {
        return Text(
          getFormattedLastMessageAt(data).toUpperCase(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 10,
              ),
        );
      },
    );
  }

  Widget _getUnreadCount() {
    return BetterStreamBuilder<int>(
      stream: widget.channel.state!.unreadCountStream,
      initialData: widget.channel.state?.unreadCount ?? 0,
      builder: (context, count) {
        if (count == 0) {
          return const SizedBox();
        }
        return CircleAvatar(
          radius: 12,
          backgroundColor: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              count.toString(),
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontSize: 10, color: kWhite),
            ),
          ),
        );
      },
    );
  }
}

class _Story extends StatelessWidget {
  const _Story();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 134,
      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stories',
                  style: kHeadingStyle1(
                      fontSize: 18, color: Theme.of(context).primaryColorDark)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _StoryCard(
                        storyData: StoryData(
                            name: faker.person.firstName(),
                            url: randomImageUrl()));
                  },
                  scrollDirection: Axis.horizontal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({super.key, required this.storyData});
  final StoryData storyData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Avatar.medium(imageUrl: storyData.url),
        const SizedBox(height: 8),
        Text(storyData.name,
            style: kBodyStyle1(color: Theme.of(context).primaryColorDark)),
      ]),
    );
  }
}
