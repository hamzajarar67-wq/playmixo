import 'package:flutter/material.dart';
class PlaymixoSplash extends StatefulWidget {
  const PlaymixoSplash({super.key});

  @override
  State<PlaymixoSplash> createState() => _PlaymixoSplashState();
}

class _PlaymixoSplashState extends State<PlaymixoSplash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Playmixo logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4AF37),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.35),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'PLAYMIXO',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                color: Color(0xFFD4AF37),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'PLAY • CONNECT • ENJOY',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const PlaymixoApp());
}

/* ================= COLORS ================= */

const gold = Color(0xFFD4AF37);
const darkGold = Color(0xFFB28A18);
const black = Color(0xFF111111);
const bg = Color(0xFFF6F6F4);

/* ================= APP ================= */

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
      home: const PlaymixoSplash(),
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
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          Row(
            children: [
              const Text(
                '♛',
                style: TextStyle(
                  color: gold,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'Playmixo',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /* WELCOME */
          Container(
            height: 82,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gold, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 59,
                  height: 59,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: gold, width: 2),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'PLAYMIXO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: gold,
                  size: 28,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /* NEW EVENT */
          Container(
            height: 94,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF2B2B2B)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Event',
                        style: TextStyle(
                          color: gold,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Big Rewards Await You!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 7),
                      SmallGoldButton(text: 'Join Now'),
                    ],
                  ),
                ),
                const Icon(
                  Icons.card_giftcard_rounded,
                  color: gold,
                  size: 58,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /* FIRST ROW */
          Row(
            children: const [
              Expanded(
                child: HomeVisualCard(
                  title: 'New Board',
                  visual: BoardVisual(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: HomeVisualCard(
                  title: 'New Card',
                  visual: CardVisual(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: HomeVisualCard(
                  title: 'New Card Box',
                  visual: BoxVisual(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: HomeVisualCard(
                  title: 'New Event',
                  visual: GiftVisual(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          /* SECOND ROW */
          Row(
            children: const [
              Expanded(
                child: HomeIconCard(
                  title: 'Free Reward',
                  icon: Icons.card_giftcard_rounded,
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: HomeIconCard(
                  title: 'Daily Task',
                  icon: Icons.assignment_turned_in_rounded,
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: HomeIconCard(
                  title: 'Update',
                  icon: Icons.campaign_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: const [
              Text(
                'Featured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Spacer(),
              Text(
                'See All ›',
                style: TextStyle(
                  color: darkGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /* FEATURED */
          Container(
            height: 92,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lucky Spin Event',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Spin & Win Amazing Rewards!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 7),
                      SmallGoldButton(text: 'Join Now'),
                    ],
                  ),
                ),
                const Icon(
                  Icons.casino_rounded,
                  color: gold,
                  size: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= HOME VISUAL CARDS ================= */

class HomeVisualCard extends StatelessWidget {
  final String title;
  final Widget visual;

  const HomeVisualCard({
    super.key,
    required this.title,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Expanded(child: Center(child: visual)),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeIconCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const HomeIconCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 91,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: gold, size: 30),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REAL-LOOKING CARD ================= */

class CardVisual extends StatelessWidget {
  const CardVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 55,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 5,
            child: Transform.rotate(
              angle: -0.18,
              child: _PlayingCard(
                symbol: '♠',
                number: 'A',
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 1,
            child: Transform.rotate(
              angle: 0.08,
              child: _PlayingCard(
                symbol: '♠',
                number: 'A',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayingCard extends StatelessWidget {
  final String symbol;
  final String number;

  const _PlayingCard({
    required this.symbol,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 49,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1, 2),
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REAL-LOOKING BOARD ================= */

class BoardVisual extends StatelessWidget {
  const BoardVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: gold, width: 2),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(1, 2),
            color: Colors.black26,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 43,
          height: 31,
          decoration: BoxDecoration(
            color: const Color(0xFF302817),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: gold),
          ),
          child: const Center(
            child: Icon(
              Icons.star_rounded,
              color: gold,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= REAL-LOOKING BOX ================= */

class BoxVisual extends StatelessWidget {
  const BoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 59,
      height: 54,
      child: Stack(
        children: [
          Positioned(
            top: 9,
            left: 5,
            child: Container(
              width: 50,
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: gold, width: 1.5),
              ),
              child: const Center(
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: gold,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            top: 3,
            left: 8,
            child: Container(
              width: 44,
              height: 11,
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: gold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= GIFT ================= */

class GiftVisual extends StatelessWidget {
  const GiftVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.card_giftcard_rounded,
      color: gold,
      size: 42,
    );
  }
}

/* ================= ROOMS ================= */

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
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
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Room',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Icon(Icons.search_rounded),
              ],
            ),
          ),

          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  Container(
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const TabBar(
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
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
                  const SizedBox(height: 9),
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
          ),
        ],
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
    final rooms = [
      ('Tash Lovers', '128 online', Icons.style_rounded),
      ('Chill Zone', '95 online', Icons.workspace_premium_rounded),
      ('Friends Room', '76 online', Icons.groups_rounded),
      ('VIP Room', '54 online', Icons.emoji_events_rounded),
      ('Fun Time', '41 online', Icons.casino_rounded),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];

        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 61,
                height: 61,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: gold,
                    width: 1,
                  ),
                ),
                child: Icon(
                  room.$3,
                  color: gold,
                  size: 31,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myRoom
                          ? 'My ${room.$1}'
                          : room.$1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 14,
                          color: gold,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          room.$2,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.person_rounded,
                          size: 13,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '2 - 4 Players',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (popular || index == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8B9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        index == 1 ? 'Hot' : 'Popular',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    width: 58,
                    height: 27,
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Join',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 17, 18, 20),
        children: [
          Row(
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
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Tash',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /* PLAY TASH HEADER */
          Container(
            height: 147,
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: gold,
                width: 1.4,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  left: 22,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 27,
                  ),
                ),
                const Positioned(
                  right: 22,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 27,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.style_rounded,
                        color: gold,
                        size: 40,
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Play Tash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Classic • Fun • Challenge',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Players',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: PlayerVisualCard(
                  title: '1 Player',
                  count: 1,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: PlayerVisualCard(
                  title: '2 Players',
                  count: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const PlayerVisualCard(
            title: '4 Players',
            count: 4,
          ),

          const SizedBox(height: 18),

          const Text(
            'Game Items',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: GameVisualItem(
                  title: 'Tash Card',
                  visual: CardVisual(),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GameVisualItem(
                  title: 'Board',
                  visual: BoardVisual(),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GameVisualItem(
                  title: 'Box',
                  visual: BoxVisual(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerVisualCard extends StatelessWidget {
  final String title;
  final int count;

  const PlayerVisualCard({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0D6AD),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                count,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.person_rounded,
                    size: 25,
                    color: black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class GameVisualItem extends StatelessWidget {
  final String title;
  final Widget visual;

  const GameVisualItem({
    super.key,
    required this.title,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE0D6AD),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            child: Center(child: visual),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= WALLET ================= */
/* USER SAID DO NOT CHANGE */

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
/* USER SAID DO NOT CHANGE */

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
          SettingItem(
            Icons.delete_outline,
            'Delete Account',
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

/* ================= SMALL BUTTON ================= */

class SmallGoldButton extends StatelessWidget {
  final String text;

  const SmallGoldButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: gold,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: black,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
