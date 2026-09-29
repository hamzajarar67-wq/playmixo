import 'package:flutter/material.dart';

void main() {
  runApp(const PlaymixoApp());
}

class PlaymixoApp extends StatelessWidget {
  const PlaymixoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Playmixo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F8F6),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

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
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFF1E5B8),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.meeting_room_outlined),
            selectedIcon: Icon(Icons.meeting_room),
            label: 'Rooms',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Game',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}

/* ========================= HOME ========================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Playmixo',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          const SectionTitle(title: 'New Board'),
          const SizedBox(height: 10),
          const FeatureCard(
            icon: Icons.dashboard_customize_outlined,
            title: 'New Board',
            subtitle: 'Choose your board',
          ),
          const SizedBox(height: 12),
          const SectionTitle(title: 'New Card'),
          const SizedBox(height: 10),
          const FeatureCard(
            icon: Icons.style_outlined,
            title: 'New Card',
            subtitle: 'Discover new cards',
          ),
          const SizedBox(height: 12),
          const SectionTitle(title: 'New Card Box'),
          const SizedBox(height: 10),
          const FeatureCard(
            icon: Icons.inventory_2_outlined,
            title: 'New Card Box',
            subtitle: 'Open your card box',
          ),
          const SizedBox(height: 18),
          const HomeTile(
            icon: Icons.celebration_outlined,
            title: 'New Event',
          ),
          const HomeTile(
            icon: Icons.card_giftcard_outlined,
            title: 'Free Reward',
          ),
          const HomeTile(
            icon: Icons.task_alt_outlined,
            title: 'Daily Task Reward',
          ),
          const HomeTile(
            icon: Icons.campaign_outlined,
            title: 'Update',
          ),
        ],
      ),
    );
  }
}

/* ========================= ROOMS ========================= */

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Rooms',
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              labelColor: Color(0xFFB08A19),
              unselectedLabelColor: Colors.black54,
              indicatorColor: Color(0xFFD4AF37),
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Popular'),
                Tab(text: 'My Room'),
              ],
            ),
            Expanded(
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
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFF1E5B8),
              child: Icon(
                Icons.mic,
                color: const Color(0xFFB08A19),
              ),
            ),
            title: Text(
              myRoom ? 'My Room ${index + 1}' : 'Playmixo Room ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              popular ? 'Popular • ${20 + index} people' : '${8 + index} people',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFB08A19),
            ),
          ),
        );
      },
    );
  }
}

/* ========================= GAME ========================= */

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Tash',
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const SizedBox(height: 8),
          const Text(
            'Choose Players',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: PlayerCard(title: '1 Player')),
              SizedBox(width: 10),
              Expanded(child: PlayerCard(title: '2 Players')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: PlayerCard(title: '4 Players')),
            ],
          ),
          const SizedBox(height: 24),
          const FeatureCard(
            icon: Icons.style,
            title: 'Tash Card',
            subtitle: 'Original Playmixo card game',
          ),
          const SizedBox(height: 12),
          const FeatureCard(
            icon: Icons.grid_on,
            title: 'Board',
            subtitle: 'Play on the Playmixo board',
          ),
          const SizedBox(height: 12),
          const FeatureCard(
            icon: Icons.inventory_2,
            title: 'Box',
            subtitle: 'Your Tash card box',
          ),
        ],
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final String title;

  const PlayerCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/* ========================= WALLET ========================= */

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Wallet',
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            BalanceCard(
              title: 'Coins',
              value: '0',
              icon: Icons.monetization_on_outlined,
            ),
            const SizedBox(height: 16),
            BalanceCard(
              title: 'Diamonds',
              value: '0',
              icon: Icons.diamond_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const BalanceCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFD4AF37),
            size: 42,
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ========================= PROFILE ========================= */

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 48,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person,
              size: 50,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Playmixo User',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'UID: 000000',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              ProfileStat(title: 'Followers', value: '0'),
              ProfileStat(title: 'Following', value: '0'),
              ProfileStat(title: 'Gift Sent', value: '0'),
              ProfileStat(title: 'Gift Received', value: '0'),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStat({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

/* ========================= SETTINGS ========================= */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          SettingItem(icon: Icons.lock_outline, title: 'Privacy'),
          SettingItem(icon: Icons.person_outline, title: 'Account'),
          SettingItem(icon: Icons.language, title: 'Language'),
          SettingItem(icon: Icons.help_outline, title: 'Help Center'),
          SettingItem(icon: Icons.logout, title: 'Log Out'),
          SettingItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            danger: true,
          ),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          icon,
          color: danger ? Colors.red : const Color(0xFFB08A19),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: danger ? Colors.red : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

/* ========================= COMMON UI ========================= */

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
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFD4AF37),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
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

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: 27,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFB08A19),
          ),
        ],
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const HomeTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFD4AF37),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Color(0xFFD4AF37),
        ),
      ),
    );
  }
}
