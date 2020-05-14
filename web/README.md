# Web

```
flutter pub run build_runner watch --delete-conflicting-outputs
```

# Running the app

We use OAuth via Firebase Authentication for Web Apps, which requires to declare trusted JavaScript sources. By default Flutter picks a random port to launch but we need to have a fixed port to let OAuth know it's us. 

Use this command to run the app: 
```
flutter run -d chrome --web-hostname localhost --web-port 7357
```

Also note that you have to use the app in Chrome as-is. That is, you should *ignore* the window opened by Flutter once the web app is launched as it uses a debug version of Chrome (which is categorized as an unsafe browser by Google) and use a normal Chrome instance instead.