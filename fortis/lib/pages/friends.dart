import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // test users
  final List<Map<String, dynamic>> _testFriends = [
    {'username': 'Test1', 'id': '1', 'avatarIndex': '0'},
    {'username': 'Test2', 'id': '2', 'avatarIndex': '1'},
    {'username': 'Test3', 'id': '3', 'avatarIndex': '2'},
    {'username': 'Test4', 'id': '4', 'avatarIndex': '3'},
  ];
  final List<Map<String, dynamic>> _testAllUsers = [
    {'username': 'Test1', 'id': '1', 'avatarIndex': '0'},
    {'username': 'Test2', 'id': '2', 'avatarIndex': '1'},
    {'username': 'Test3', 'id': '3', 'avatarIndex': '2'},
    {'username': 'Test4', 'id': '4', 'avatarIndex': '3'},
    {'username': 'Test5', 'id': '5', 'avatarIndex': '4'},
    {'username': 'Test6', 'id': '6', 'avatarIndex': '5'},
    {'username': 'Test7', 'id': '7', 'avatarIndex': '6'},
  ];

  final List<String> _avatarOptions = const [
    'assets/avatars/avatar_1.png',
    'assets/avatars/avatar_2.png',
    'assets/avatars/avatar_3.png',
    'assets/avatars/avatar_4.png',
    'assets/avatars/avatar_5.png',
    'assets/avatars/avatar_6.png',
    'assets/avatars/avatar_7.png',
    'assets/avatars/avatar_8.png',
    'assets/avatars/avatar_9.png',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  List<Map<String, dynamic>> get _displayedUsers {
    if (_searchQuery.isEmpty) {
      return _testFriends;
    } else {
      return _testAllUsers
          .where((user) =>
              user['username']!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  List<Map<String, dynamic>> get _recommendedFriends {
    return _testAllUsers
        .where((user) => !_testFriends.any((friend) => friend['id'] == user['id']))
        .toList();
  }

  void _userProfileClick(Map<String, dynamic> user) {
    final bool isFriend = _testFriends.any((friend) => friend['id'] == user['id']);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendProfilePage(
          username: user['username']!,
          avatarIndex: user['avatarIndex']!,
          isFriend: isFriend,
          streakCount: isFriend ? 3 : 0, 
          achievements: isFriend ? ['Consistency'] : [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Username',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _displayedUsers.length,
            itemBuilder: (context, index) {
              final user = _displayedUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(_avatarOptions[int.parse(user['avatarIndex']!)]),
                ),
                title: Text(user['username']!),
                onTap: () => _userProfileClick(user),
              );
            },
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Recommended Friends',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3, 
          child: ListView.builder(
            itemCount: _recommendedFriends.length,
            itemBuilder: (context, index) {
              final user = _recommendedFriends[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(_avatarOptions[int.parse(user['avatarIndex']!)]),
                ),
                title: Text(user['username']!),
                onTap: () => _userProfileClick(user),
              );
            },
          ),
        ),
      ],
    );
  }
}


class FriendProfilePage extends StatelessWidget {
  final String username;
  final String avatarIndex;
  final bool isFriend;
  final int streakCount;
  final List<String> achievements;

  final List<String> _avatarOptions = const [
    'assets/avatars/avatar_1.png',
    'assets/avatars/avatar_2.png',
    'assets/avatars/avatar_3.png',
    'assets/avatars/avatar_4.png',
    'assets/avatars/avatar_5.png',
    'assets/avatars/avatar_6.png',
    'assets/avatars/avatar_7.png',
    'assets/avatars/avatar_8.png',
    'assets/avatars/avatar_9.png',
  ];

  const FriendProfilePage({
    super.key,
    required this.username,
    required this.avatarIndex,
    required this.isFriend,
    required this.streakCount,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(_avatarOptions[int.parse(avatarIndex)]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (!isFriend)
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Friend request sent.')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Send Request'),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Streak', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('$streakCount days', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text('Achievements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (achievements.isNotEmpty)
              Wrap(
                spacing: 8.0,
                children: achievements.map((achievement) => Chip(label: Text(achievement))).toList(),
              )
            else
              const Text('No achievements yet.'),
          ],
        ),
      ),
    );
  }
}