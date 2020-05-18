import 'package:web/global.dart';
import 'package:web/services/navigation/navigation_routes.dart';
import 'package:web/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:web/services/navigation/router.dart';
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
    final token = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImY1YzlhZWJlMjM0ZGE2MDE2YmQ3Yjk0OTE2OGI4Y2Q1YjRlYzllZWIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYW5ncnktc2hpcHMtMTU4OTA1NjQ3MDc1MiIsImF1ZCI6ImFuZ3J5LXNoaXBzLTE1ODkwNTY0NzA3NTIiLCJhdXRoX3RpbWUiOjE1ODk4MjkyNzIsInVzZXJfaWQiOiJJRlRqZHdMU1ZaUkhKeFJTa3A4S2FSeTVmYkIzIiwic3ViIjoiSUZUamR3TFNWWlJISnhSU2twOEthUnk1ZmJCMyIsImlhdCI6MTU4OTgyOTI3MiwiZXhwIjoxNTg5ODMyODcyLCJlbWFpbCI6InRlc3RAdGVzLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ0ZXN0QHRlcy5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.bAavRFI48M3uYMpvKznu7vOigt2UeCJ0tXqVNBjyAHDhuBwu5arNfdME1MVheqQZQNUVaSCra-Zlgihdltn0g_g3Tc9nMM2nUtH3htzh8IDRHP-JATGViLhs_dnH-fJvoAw7XY3PJzba0F5TNaJqCFvpWmRMLWI2clB_dB4PVtUjcd2NxTu5by9YKPKNC4AQwLP6D6U9OH_L1tkNKNq9ba-hHjZySdQNt2BgwhUucrlxA6l5SMao7g-ZKZnqYeiG_ddf4YGNp0QQcqrTWBYI6u5l-6qIJuGIiGP5UxVez3Qj0l7kPjI8Ctbkix0RyhlHUfyVRvFeCRQ2IKhkNwbuXA";
    
    final userService = new UserService("http://localhost:3000");
    await userService.createUser(token);
    final user = await userService.getUser("IFTjdwLSVZRHJxRSkp8KaRy5fbB3", token);
    print('User id: ${user.id.id}');
  }
}
