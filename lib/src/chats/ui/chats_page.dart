import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:bootcamp_project/src/chats/ui/search_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ChatsPage extends StatelessWidget {
  final List<Chat> chats;

  const ChatsPage({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
              color: Colors.black,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 140.0, right: 140.0),
              child: Text('App',
                  style: TextStyle(color: Colors.black, fontSize: 30.0)),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SearchPage(chats: chats)));
                },
                icon: const Icon(Icons.search),
                color: Colors.black),
          ],
        ),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(Duration(days: 1));
          final lastWeek = today.subtract(Duration(days: 7));

          String formattedDate;
          if (chat.date == null) {
            formattedDate = '';
          } else if (chat.date?.isAfter(today) == true) {
            formattedDate = DateFormat.Hm().format(chat.date!);
          } else if (chat.date?.isAfter(yesterday) == true) {
            formattedDate = 'Вчера';
          } else if (chat.date?.isAfter(lastWeek) == true) {
            formattedDate = DateFormat.E().format(chat.date!);
          } else {
            formattedDate =
                '${DateFormat.d().format(chat.date!)} ${DateFormat.MMMM().format(chat.date!)}';
          }
          return chat.lastMessage != null
              ? ListTile(
                  leading: chat.userAvatar != null
                      ? CircleAvatar(
                          backgroundImage: AssetImage(chat.userAvatar!),
                        )
                      : Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)],
                                    Colors.white,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                child: Text(
                                  chat.userName[0],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              width: 50.0,
                              height: 50.0,
                            ),
                          ],
                        ),
                  title: Text(chat.userName),
                  subtitle:
                      chat.lastMessage != null ? Text(chat.lastMessage!) : null,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (chat.date != null) Text(formattedDate),
                      if (chat.countUnreadMessages > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.red,
                          ),
                          child: Text(
                            chat.countUnreadMessages.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {},
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
