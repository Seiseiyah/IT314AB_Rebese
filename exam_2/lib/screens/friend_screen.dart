import 'package:exam_2/data/friend_data.dart';
import 'package:exam_2/models/friend.dart';
import 'package:flutter/material.dart';

class FriendClassScreen extends StatefulWidget {
  const FriendClassScreen({super.key});

  @override
  State<FriendClassScreen> createState() => _FriendClassScreenState();
}

class _FriendClassScreenState extends State<FriendClassScreen> {
  int _selectedIndex = 0;

  void _toggleReadStatus(int index) {
    setState(() {
      FriendData.markAsRead(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedFriend = FriendData.friends[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF2B2628),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth >= 600;

            return Row(
              children: [
                SizedBox(
                  width: isWideScreen ? 400 : constraints.maxWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: isWideScreen
                          ? const Border(
                              right: BorderSide(color: Color(0xFF302C2E)),
                            )
                          : null,
                    ),
                    child: _InboxPanel(
                      selectedIndex: _selectedIndex,
                      onSelect: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                if (isWideScreen)
                  Expanded(
                    child: _ConversationPanel(
                      friend: selectedFriend,
                      onMarkAsRead: () => _toggleReadStatus(_selectedIndex),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InboxPanel extends StatelessWidget {
  const _InboxPanel({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final friends = FriendData.friends;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
          child: Text(
            'Social',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEDE8E9),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _Tab(label: 'Friends', isSelected: true),
                _Tab(label: 'Messages'),
                _Tab(label: 'Requests'),
              ],
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFF3A3235),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: friends.isEmpty
              ? const Center(
                  child: Text(
                    'No friends available',
                    style: TextStyle(color: Color(0xFFEDE8E9)),
                  ),
                )
              : ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    final isSelected = index == selectedIndex;

                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: const Color(0xFF3A3235),
                      onTap: () => onSelect(index),
                      leading: Stack(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: friend.isOnline
                                    ? Colors.green
                                    : Colors.grey,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF2B2628),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              friend.name,
                              style: TextStyle(
                                color: Color(0xFFEDE8E9),
                                fontWeight: friend.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!friend.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF4655),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        friend.status,
                        style: const TextStyle(color: Color(0xFFB8B0B4)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 28),
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(color: Color(0xFFFF4655), width: 2),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _ConversationPanel extends StatelessWidget {
  const _ConversationPanel({required this.friend, required this.onMarkAsRead});

  final Friend friend;
  final VoidCallback onMarkAsRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFF302C2E))),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                child: Text(friend.name.substring(0, 1).toUpperCase()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conversation with ${friend.name}',
                      style: const TextStyle(
                        color: Color(0xFFEDE8E9),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      friend.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: friend.isOnline ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3A3235),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.isRead ? 'Read' : 'Unread',
                  style: TextStyle(
                    color: friend.isRead
                        ? Colors.green
                        : const Color(0xFFFF4655),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  friend.status,
                  style: const TextStyle(color: Color(0xFFEDE8E9)),
                ),
                if (friend.isPlaying)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Currently playing',
                      style: TextStyle(color: Color(0xFFC9BFC3)),
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: friend.isRead ? null : onMarkAsRead,
            icon: const Icon(Icons.check),
            label: const Text('Mark as read'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4655),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ),
    );
  }
}
