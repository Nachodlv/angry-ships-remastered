import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web/data_structures/remote_data.dart';
import 'package:web/global.dart';
import 'package:web/models/auth.dart';
import 'package:web/services/auth/auth_service.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:web/services/websockets/room_ws_service.dart';
import 'package:web/services/websockets/socket_manager.dart';
import 'package:web/ui/room/room_view.dart';
import 'package:flutter/scheduler.dart';


class HomeViewModel extends ChangeNotifier {
  final Credentials credentials;
  final String userId;

  HomeViewModel({this.credentials, this.userId});

  Socket socket;

  NavigationService _navigationService = locator<NavigationService>();
  RoomWsService _roomWsService = locator<RoomWsService>();
  SocketManager _socketManager = locator<SocketManager>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  RemoteData<String, Unit> roomData = RemoteData.notAsked();

  init() async {

    if(this.credentials == null || this.userId == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) => _navigationService.navigateTo(Routes.LOAD));
        return;
    } 
    socket = await _socketManager.connect(credentials.token);

    _roomWsService.onRoomOpened.listen(
            (roomId) {
          _setRoomData(RemoteData.success(unit));
          _navigationService.navigateTo(Routes.ROOM, arguments: RoomViewArguments(socket: socket, id: roomId, userCredentials: this.credentials, userId: this.userId));
        }
    );

    _socketManager.onError.listen((errorMsg) {
      _setRoomData(RemoteData.error(errorMsg));
      print('Oops! $errorMsg');
    });
    
    
  }
  
  navigateToLoad() async {
  }

  play() {
    _setRoomData(RemoteData.loading());
    _roomWsService.findRoom(socket).then((response) {
      if(!response.startFinding) _setRoomData(RemoteData.error(response.message));
    });
  }
  
  signOut() {
    try {
      _setRoomData(RemoteData.loading());
      _authenticationService.signOut()
          .then((_) => _navigationService.navigateTo(Routes.LOGIN))
          .catchError(() => _setRoomData(RemoteData.error("Couldn't sign out")));
    }catch (e) {
      print(e);
    }
  }
  
  _setRoomData(RemoteData<String, Unit> data) {
    roomData = data;
    notifyListeners();
  }
}