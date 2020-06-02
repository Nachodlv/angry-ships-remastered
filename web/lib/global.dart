import 'package:firebase_core/firebase_core.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/auth/auth_service_firebase.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/user/user_service.dart';
import 'package:web/services/websockets/boat_placement_ws_service.dart';
import 'package:web/services/websockets/chat_ws_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/shoot_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final url = 'http://localhost:3000';
  final app = await FirebaseApp.configure(
    name: "Angry Ships", 
    options: FirebaseOptions(
      googleAppID: '1:996135798667:web:45348834f2e9229f29d18e',
      gcmSenderID: '996135798667',
      apiKey: 'AIzaSyB8L8ZiTkzhjyewlvClmQ7U4kLBlynoK4g',
      projectID: 'angry-ships-1589056470752',
    ));
  
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<AuthenticationService>(AuthenticationServiceFirebase(app));
  locator.registerSingleton<SocketManager>(SocketManager(url));
  locator.registerSingleton<RoomService>(RoomService(url));
  locator.registerSingleton<UserService>(UserService(url));
  
  locator.registerSingleton<ChatWsService>(ChatWsService()); 
  locator.registerSingleton<RoomWsService>(RoomWsService());
  locator.registerSingleton<BoatPlacementWsService>(BoatPlacementWsService());
  locator.registerSingleton<ShootWsService>(ShootWsService());
}

const int kTilesPerRow = 10;
const int kTilesQuantity = kTilesPerRow * kTilesPerRow;
