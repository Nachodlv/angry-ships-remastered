'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "4bf9d0106b4d8f633b475abc840de5f2",
"assets/assets/credentials/firebase-credentials.json": "49c1fdca204273cb00c91106d6377d37",
"assets/assets/fonts/teko/Teko-Bold.ttf": "8ec04ac829a7ea0d0b4d684e40e46a80",
"assets/assets/fonts/teko/Teko-Light.ttf": "6975ea7fd41ff1aad79fc0f0e0813f73",
"assets/assets/fonts/teko/Teko-Medium.ttf": "6229081b736b43b9c7477c47e272141e",
"assets/assets/fonts/teko/Teko-Regular.ttf": "b35fa5f3177a8afc45d037059d2ec630",
"assets/assets/fonts/teko/Teko-SemiBold.ttf": "22c16defcbfb5992927adf6c94cd414f",
"assets/assets/images/google_logo.png": "afd0abffc72b29380e89f04333ecdaef",
"assets/assets/images/logo.png": "47abe7795d612bb884619d3a471bb7b0",
"assets/FontManifest.json": "e1283e94d6bb92601f08458eb65a4e67",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/LICENSE": "9efbbba16548d27457a4f3f0899be515",
"index.html": "0f6b6608da159675ab8e65159f2cda31",
"/": "0f6b6608da159675ab8e65159f2cda31",
"main.dart.js": "fccccef874a47af50590670b6ed6522f"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
