import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:is_spam/widgets/mini/recomte_configure.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:is_spam/providers/sms_provider.dart';
import 'package:is_spam/widgets/sms_list_item.dart';
import 'package:is_spam/widgets/sms_list_loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SmsProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Defender SMS',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C5CE7),
              primary: const Color(0xFF6C5CE7),
              secondary: const Color(0xFF00CEC9),
            ),
            scaffoldBackgroundColor: const Color(0xFFF9FAFB),
            textTheme: GoogleFonts.outfitTextTheme(),
          ),
          home: const AppGate(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final provider = context.read<SmsProvider>();
        switch (_tabController.index) {
          case 0:
            provider.setFilter(FilterType.all);
            break;
          case 1:
            provider.setFilter(FilterType.spam);
            break;
          case 2:
            provider.setFilter(FilterType.ham);
            break;
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SmsProvider>().fetchMessages();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: autherMedia == true ? const AutherMedia() : null,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Defender SMS',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              labelColor: Colors.white,
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),

              // unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              unselectedLabelColor: const Color(0xFF636E72),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Spam'),
                Tab(text: 'Safe'),
              ],
            ),
            // bottom: TabBar(
            //   controller: _tabController,
            //   indicatorColor: const Color(0xFF6C5CE7),
            //   labelColor: const Color(0xFF6C5CE7),
            //   unselectedLabelColor: Colors.grey,
            //   indicatorSize: TabBarIndicatorSize.tab,
            //   tabs: const [
            //     Tab(text: 'All'),
            //     Tab(text: 'Spam'),
            //     Tab(text: 'Ham'),
            //   ],
            // ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          Consumer<SmsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const SmsListLoading();
              }

              if (provider.errorMessage.isNotEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Oops!',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.errorMessage,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF636E72),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () => provider.fetchMessages(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C5CE7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (provider.messages.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C5CE7).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.sms_outlined,
                            size: 48,
                            color: Color(0xFF6C5CE7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Messages Found',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your inbox is clean!',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF636E72),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return SmsListItem(message: provider.messages[index]);
                  }, childCount: provider.messages.length),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SmsProvider>().fetchMessages(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
