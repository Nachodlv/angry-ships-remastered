import 'package:web/global.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:web/services/navigation/router.dart';
import 'package:web/services/room/room_service.dart';
import 'package:web/services/user/user_service.dart';

void main() async {
  await setupLocator();
  runApp(App());
}

ThemeData AngryShipsTheme(BuildContext context) => ThemeData(
  textTheme: Theme.of(context).textTheme.apply(
    fontFamily: 'Poppins',
  ),
);

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    test();
    return MaterialApp(
      title: 'Angry Ships',
      color: Colors.white,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: RoutesGenerator.onGenerateRoute,
      initialRoute: Routes.LOAD,
      theme: AngryShipsTheme(context)
    );
  }

  test() async {
    final token = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImY1YzlhZWJlMjM0ZGE2MDE2YmQ3Yjk0OTE2OGI4Y2Q1YjRlYzllZWIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYW5ncnktc2hpcHMtMTU4OTA1NjQ3MDc1MiIsImF1ZCI6ImFuZ3J5LXNoaXBzLTE1ODkwNTY0NzA3NTIiLCJhdXRoX3RpbWUiOjE1ODk4MzkzMDQsInVzZXJfaWQiOiJJRlRqZHdMU1ZaUkhKeFJTa3A4S2FSeTVmYkIzIiwic3ViIjoiSUZUamR3TFNWWlJISnhSU2twOEthUnk1ZmJCMyIsImlhdCI6MTU4OTgzOTMwNCwiZXhwIjoxNTg5ODQyOTA0LCJlbWFpbCI6InRlc3RAdGVzLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ0ZXN0QHRlcy5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.hyBWm6-Ipkgaze7Wz4erDO_eCsg7Uepird0QvsMfcDsveg-Z7Et7YnAdFrK9jSQ7c1rgv13T5RgTgDTZPRUUA0U2S7MTD34xJjb-tlP-ugW3O_IcOy246Rw8LWVfaD0Cfp1GtIJfMgAL7eC6SfFeETZsnA3PvsXUh9a8MRyQdK_a53cAZoY1x5q1aJ0CT4W80e2law1OPOk8BBdqXe8wJ8cg3723F4XtpY1mgq_efN4qBU0NYFPnFBgBu-FPr8Z2VexdTNXOGNBR3fdzuE5D_1W2-N6ruyatFZZkdn2gH8Ie5oPgU_9HaOj8-Zd_PcviwcAwTWQI56ZlvOrIzll20w";
    final url = "http://localhost:3000";

    final userService = new UserService(url);
    await userService.createUser(token);
    final user = await userService.getUser("IFTjdwLSVZRHJxRSkp8KaRy5fbB3", token);
    print('User id: ${user.id.id}');

    final roomService = new RoomService(url);
    final room = await roomService.getRoomById('dc3c97a5-be48-4fbb-b97d-b7cc6b839dcd', token);
    print('Users in room: ' + room.users.reduce((value, element) => '$value, $element'));
  }
}
