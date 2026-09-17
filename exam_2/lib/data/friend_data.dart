import 'package:exam_2/models/friend.dart';

class FriendData {
  static final List<Friend> friends = [
    Friend(
      name: 'MissYouLikeKrazy',
      status: 'Online - VALORANT',
      device: 'computer',
      section: 'VALORANT',
      isPlaying: false,
      isOnline: true,
      isRead: false,
    ),
    Friend(
      name: 'bread',
      status: 'Playing - VALORANT',
      device: 'computer',
      section: 'VALORANT',
      isPlaying: true,
      isOnline: true,
      isRead: true,
    ),
    Friend(
      name: 'The14th',
      status: 'Playing - VALORANT',
      device: 'computer',
      section: 'VALORANT',
      isPlaying: true,
      isOnline: true,
      isRead: false,
    ),
    Friend(
      name: 'Carlvendish',
      status: 'Away - Riot Mobile',
      device: 'mobile',
      section: 'Friends',
      isPlaying: false,
      isOnline: false,
      isRead: true,
    ),
    Friend(
      name: 'D1yah',
      status: 'Away - Riot Mobile',
      device: 'mobile',
      section: 'Friends',
      isPlaying: false,
      isOnline: false,
      isRead: false,
    ),
  ];

  static void markAsRead(int index) {
    if (index < 0 || index >= friends.length) return;

    final friend = friends[index];
    friends[index] = Friend(
      name: friend.name,
      status: friend.status,
      device: friend.device,
      section: friend.section,
      isPlaying: friend.isPlaying,
      isOnline: friend.isOnline,
      isRead: true,
    );
  }
}
