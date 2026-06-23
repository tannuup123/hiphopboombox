import 'dart:convert';
import 'dart:io';

import 'package:boombox/bloc/bottom_block.dart';
import 'package:boombox/bloc/bottom_event.dart';
import 'package:boombox/bloc/bottom_state.dart';
import 'package:boombox/modal/postmodal.dart';
import 'package:boombox/screens/blocked_users/blocked_user_cubit.dart';
import 'package:boombox/screens/blocked_users/no_content.dart';
import 'package:boombox/screens/main_screens/account/account.dart';
import 'package:boombox/screens/main_screens/account/account_cubit.dart';
import 'package:boombox/screens/main_screens/home.dart';
import 'package:boombox/screens/main_screens/polls/poll_bloc.dart';
import 'package:boombox/screens/main_screens/polls/polls.dart';
import 'package:boombox/screens/main_screens/raffle/raffle.dart';
import 'package:boombox/screens/main_screens/raffle/raffle_cubit.dart';
import 'package:boombox/screens/main_screens/search/search.dart';
import 'package:boombox/screens/main_screens/search/search_cubit.dart';
import 'package:boombox/screens/video_screen/video_detail.dart';
import 'package:boombox/theme/dark_theme.dart';
import 'package:boombox/theme/light_theme.dart';
import 'package:boombox/theme/theme_cubit.dart';
import 'package:boombox/theme/theme_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/data_bloc.dart';
import 'firebase_options.dart';

import 'package:rxdart/rxdart.dart';

import 'modal/user_details.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import localization
// used to pass messages from event handler to the UI
final _messageStreamController = BehaviorSubject<RemoteMessage>();

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(Platform.isIOS){
    _requestPermission();
  }
  _getToken();
  //todo : change this to all
  _subscribeToTopic('all');
  _setupForegroundMsg();
  final prefs=await SharedPreferences.getInstance();
  UserDetails.id= prefs.getString('userId');

  runApp(const MyApp());
}

Future<void> _requestPermission() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
}

void _setupForegroundMsg(){
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });
}

Future<void> _getToken() async {
  final messaging = FirebaseMessaging.instance;
  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }
}

void _subscribeToTopic(String topic) async {
  final messaging = FirebaseMessaging.instance;

  try {
    await messaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  } catch (e) {
    print('Error subscribing to topic: $e');
  }
}

class MyApp extends StatelessWidget {
  final Map<String,dynamic>? map;
  const MyApp({super.key,this.map});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>ThemeCubit()..getSavedTheme())
      ],
      child: BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (BuildContext context, ThemeMode themeMode) {
          return ScreenUtilInit(
            designSize: const Size(430.0, 932.0),
            minTextAdapt: true,
            splitScreenMode: true,
            // Use builder only if you need to use library outside ScreenUtilInit context
            builder: (_ , child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                title: 'Boombox',
                // You can use the library anywhere in the app even in theme
                theme: LightTheme().lightTheme,
                darkTheme: DarkTheme().darkTheme,
                themeMode: themeMode,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  MonthYearPickerLocalizations.delegate,
                ],
                home: child,
              );
            },
            child: const MyHomePage(),
          );
        },

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _list=  [const Home(),Search(),const Polls(),const Raffle(), const Account()];

  final List<Widget> _list2=  [const NoContent(),Search(),const Polls(),const Raffle(),const Account()];

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // print("home ${message.data}");
    if (message.data['screen'] == 'video') {
      Navigator.push(context, MaterialPageRoute(builder: (builder)=>VideoDetail(postModal: PostModal.fromJson(
          jsonDecode(message.data['postData'])[0]
      ))));
    }

  }

  @override
  void initState() {
    setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context){
            return BottomBlock();
          }),
          BlocProvider(create: (context)=>FeaturedDataFetchCubit()..fetchFeaturedPosts()),
          BlocProvider(create: (context)=>CategoriesFetchCubit()),
          BlocProvider(create: (context){
            return SearchCubit()..loadPrefs();
          }),
          BlocProvider(create: (context)=>PollCubit()..fetchPoll()),
          BlocProvider(create: (context)=>VoteCubit()),
          BlocProvider(create: (context)=>RaffleCubit()..getRaffle()),

          BlocProvider(create: (context){
            return AccountCubit()..isLoggedIn();
          }),
          BlocProvider(create: (context){
            return AppVersionCubit()..getAppDetails();
          }),
          BlocProvider(create: (context){
            return BlockedUserCubit()..isAdminBlocked();
          }),
        ],
      child: BlocBuilder<BottomBlock,BottomState>(
        builder: (context,state){
          return BlocBuilder<BlockedUserCubit,bool>(
            builder: (BuildContext context, bool isAdminBlocked) {
              return Scaffold(
                // backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(child: Image.asset('assets/images/logo_white.png', height: 25.h,)),
                      // InkWell(
                      //   onTap: ()=>context.read<ThemeCubit>().changeTheme(),
                      //     child: Icon(Theme.of(context).brightness== Brightness.light? Icons.light_mode : Icons.dark_mode)),
                      SizedBox(width: 10.w,),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Switch(
                            value: Theme.of(context).brightness== Brightness.dark,
                            onChanged: (value){
                              context.read<ThemeCubit>().changeTheme();
                            },
                            thumbIcon: WidgetStatePropertyAll(Icon(Theme.of(context).brightness== Brightness.light? Icons.light_mode : Icons.dark_mode)),
                          ),
                        ),
                      )
                    ],
                  ),
                  centerTitle: true,
                ),
                body: IndexedStack(
                    index: state.index,
                    children: isAdminBlocked? _list2 : _list
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home,),
                        label: "Home"
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search,),
                        label: "Search"
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.poll,),
                        label: "Poll"
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.shop,),
                        label: "Raffle"
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_2_outlined,),
                        label: "Account"
                    ),
                  ],
                  currentIndex: state.index,
                  onTap: (index){
                    context.read<BottomBlock>().add(SelectEvent(index));
                  },
                ),
              );
            },

          );
        },
      ),
    );

  }
}
