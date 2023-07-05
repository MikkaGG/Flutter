import 'package:flutter/material.dart';
import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class SearchPage extends StatefulWidget {
  final List<Chat> chats;

  const SearchPage({Key? key, required this.chats}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filteredChats = widget.chats.where((chat) {
      final lowercaseQuery = _query.toLowerCase();
      final lowercaseUserName = chat.userName.toLowerCase();
      final lowercaseLastMessage = chat.lastMessage?.toLowerCase() ?? '';

      return lowercaseUserName.contains(lowercaseQuery) ||
          lowercaseLastMessage.contains(lowercaseQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Поиск',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: filteredChats.length,
        itemBuilder: (context, index) {
          final chat = filteredChats[index];

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
                                    Color((Random().nextDouble() * 0xFFFFFF)
                                                .toInt() <<
                                            0)
                                        .withOpacity(1.0),
                                    Colors.white,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
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
