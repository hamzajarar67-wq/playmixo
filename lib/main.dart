import 'package:flutter/material.dart';

void main() {
  runApp(const PlaymixoApp());
}

const gold = Color(0xFFD4AF37);
const darkGold = Color(0xFFB28A18);
const black = Color(0xFF111111);
const bg = Color(0xFFF6F6F4);

class PlaymixoApp extends StatelessWidget {
  const PlaymixoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Playmixo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

/* ================= MAIN ================= */

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    RoomsPage(),
    GamePage(),
    WalletPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE8E8E8)),
          ),
        ),
        child: NavigationBar(
          height: 72,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: currentIndex,
          indicatorColor: const Color(0xFFF3E8B9),
          onDestinationSelected: (index) {
            setState(() => currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: black),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.meeting_room_outlined),
              selectedIcon: Icon(Icons.meeting_room, color: black),
              label: 'Room',
            ),
            NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style, color: black),
              label: 'Game',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon:
                  Icon(Icons.account_balance_wallet, color: black),
              label: 'Wallet',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: black),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: black),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= HOME ================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Playmixo',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const WelcomeCard(),
          const SizedBox(height: 22),

          const SectionTitle('New Board'),
          const SizedBox(height: 10),
          const BigFeatureCard(
            icon: Icons.grid_view_rounded,
            title: 'New Board',
            subtitle: 'Explore the new board',
          ),

          const SizedBox(height: 18),
          const SectionTitle('New Card'),
          const SizedBox(height: 10),
          const BigFeatureCard(
            icon: Icons.style_rounded,
            title: 'New Card',
            subtitle: 'Discover new cards',
          ),

          const SizedBox(height: 18),
          const SectionTitle('New Card Box'),
          const SizedBox(height: 10),
          const BigFeatureCard(
            icon: Icons.inventory_2_rounded,
            title: 'New Card Box',
            subtitle: 'Open your card box',
          ),

          const SizedBox(height: 22),

          const HomeAction(
            icon: Icons.celebration_rounded,
            title: 'New Event',
          ),
          const HomeAction(
            icon: Icons.card_giftcard_rounded,
            title: 'Free Reward',
          ),
          const HomeAction(
            icon: Icons.task_alt_rounded,
            title: 'Daily Task Reward',
          ),
          const HomeAction(
            icon: Icons.campaign_rounded,
            title: 'Update',
          ),
        ],
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: gold, width: 1.3),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: black,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'PLAYMIXO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= ROOMS ================= */

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Room',
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                labelColor: gold,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Popular'),
                  Tab(text: 'My Room'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Expanded(
              child: TabBarView(
                children: [
                  RoomList(),
                  RoomList(popular: true),
                  RoomList(myRoom: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomList extends StatelessWidget {
  final bool popular;
  final bool myRoom;

  const RoomList({
    super.key,
    this.popular = false,
    this.myRoom = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.mic,
                  color: gold,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myRoom
                          ? 'My Room ${index + 1}'
                          : 'Playmixo Room ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      popular
                          ? 'Popular • ${20 + index} people'
                          : '${8 + index} people',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: darkGold,
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ================= GAME ================= */

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Tash',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const GameHeader(),
          const SizedBox(height: 22),

          const SectionTitle('Players'),
          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(child: PlayerCard('1 Player')),
              SizedBox(width: 10),
              Expanded(child: PlayerCard('2 Players')),
            ],
          ),

          const SizedBox(height: 10),

          const PlayerCard('4 Players'),

          const SizedBox(height: 22),

          const GameOption(
            icon: Icons.style_rounded,
            title: 'Tash Card',
          ),
          const GameOption(
            icon: Icons.grid_on_rounded,
            title: 'Board',
          ),
          const GameOption(
            icon: Icons.inventory_2_rounded,
            title: 'Box',
          ),
        ],
      ),
    );
  }
}

class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: gold, width: 1.3),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.style_rounded, color: gold, size: 38),
            SizedBox(height: 7),
            Text(
              'TASH CARD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final String title;

  const PlayerCard(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: gold, width: 1.2),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class GameOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const GameOption({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        children: [
          Icon(icon, color: gold, size: 27),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: gold,
            size: 15,
          ),
        ],
      ),
    );
  }
}

/* ================= WALLET ================= */

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Wallet',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: const [
          WalletBalance(
            icon: Icons.monetization_on_rounded,
            title: 'Coins',
            value: '0',
          ),
          SizedBox(height: 14),
          WalletBalance(
            icon: Icons.diamond_rounded,
            title: 'Diamonds',
            value: '0',
          ),
        ],
      ),
    );
  }
}

class WalletBalance extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const WalletBalance({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: gold, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: black, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= PROFILE ================= */

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: gold, width: 1.2),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 47,
                  backgroundColor: gold,
                  child: Icon(
                    Icons.person,
                    size: 53,
                    color: black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Playmixo User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'UID: 000000',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  height: 1,
                  color: Colors.white24,
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    ProfileStat('Followers'),
                    ProfileStat('Following'),
                    ProfileStat('Gift Sent'),
                    ProfileStat('Gift Received'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;

  const ProfileStat(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            '0',
            style: TextStyle(
              color: gold,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= SETTINGS ================= */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Setting',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: const [
          SettingItem(Icons.lock_outline, 'Privacy'),
          SettingItem(Icons.person_outline, 'Account'),
          SettingItem(Icons.language, 'Language'),
          SettingItem(Icons.help_outline, 'Help Center'),
          SettingItem(Icons.logout, 'Log Out'),
          SettingItem(Icons.delete_outline, 'Delete Account', danger: true),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;

  const SettingItem(
    this.icon,
    this.title, {
    super.key,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
        leading: Icon(
          icon,
          color: danger ? Colors.red : darkGold,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: danger ? Colors.red : black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: Colors.black45,
        ),
      ),
    );
  }
}

/* ================= COMMON ================= */

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 18, 17, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class BigFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const BigFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
            color: darkGold,
          ),
        ],
      ),
    );
  }
}

class HomeAction extends StatelessWidget {
  final IconData icon;
  final String title;

  const HomeAction({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Icon(icon, color: gold),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: gold,
          size: 15,
        ),
      ),
    );
  }
}
