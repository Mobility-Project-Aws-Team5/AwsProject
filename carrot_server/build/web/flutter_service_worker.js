'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c93fa20737521ca2c516d9771a8450dd",
"assets/AssetManifest.bin.json": "433d8494d91263ae5412cd83f3fc6dac",
"assets/AssetManifest.json": "2f6612a68f1ac9e32589fd8cda509d58",
"assets/assets/images/background.jpg": "7fd78cd07c7e03d6d698be3c446e05d0",
"assets/assets/images/cpu/amd%2520ryzen%25203.jpg": "295c357a4093292ea22c5341ff931f57",
"assets/assets/images/cpu/amd%2520ryzen%25205.jpg": "1ac2ada68e38fb1c5ba7ce88849fd725",
"assets/assets/images/cpu/amd%2520ryzen%25207.png": "fe948d3a472db5e8948a76d7c7ad4c90",
"assets/assets/images/cpu/AMD%2520ryzen%25209.jpg": "48398fe11fbf9cc403f2450c7edf83e1",
"assets/assets/images/cpu/intel%2520core%2520i9.jpg": "0aa32890e8bedf01445b231024a09be3",
"assets/assets/images/cpu/intel%2520i3.jpg": "6d448213be541a97f9df522d96d0544d",
"assets/assets/images/cpu/intel%2520i5.jpg": "94a7f1bf8b26b736c188c2f97a213b1d",
"assets/assets/images/cpu/intel%2520i7.jpg": "fbd48849b785b271553b53b62f41381d",
"assets/assets/images/cpu/intel%2520xeon.jpg": "8de5fbddc73df05620a2d213679eb35f",
"assets/assets/images/cpu/threadripper.jpg": "0fca3a2ab2ce9d8446b2eb95060ece1b",
"assets/assets/images/gpu/6600.jpg": "d68c53df27bc94f42ac1910959595f75",
"assets/assets/images/gpu/amd%2520590.jpg": "c4b277a8e028ccaf914b9a429936ba8d",
"assets/assets/images/gpu/amd%25206700.jpg": "4ea275418715cecd98b5af8c8e7bef3c",
"assets/assets/images/gpu/amd%25206800.jpg": "edba0d106b3739174d08fa8c223f6fdb",
"assets/assets/images/gpu/amd580.jpg": "a9c460d68f3aa100b5cecec1bed663cc",
"assets/assets/images/gpu/gtx1080.jpg": "4b070e1ad590f3d73afbcca47046dea2",
"assets/assets/images/gpu/gtx1660.jpg": "723fbc9e1cd40349ef6ae0cd559d447a",
"assets/assets/images/gpu/rtx%25203080.jpg": "839efee2224f7b9981f9178ed278d46f",
"assets/assets/images/gpu/rtx3060.jpg": "32a5e16c17c9fd506d1916a8f9eab7fd",
"assets/assets/images/gpu/rtx3070.jpg": "0b68a3b9e819fb1040e6b160e9681b82",
"assets/assets/images/keyboard/Corsair%2520K65%2520RGB.jpg": "9b7072d7a342e20fce31368896582f05",
"assets/assets/images/keyboard/Corsair%2520K70%2520RGB.jpg": "8bbf037230ca24f55c5b6dfa85ea4992",
"assets/assets/images/keyboard/Corsair%2520K95%2520RGB.jpg": "028b78e794e957a229e8696560f3f917",
"assets/assets/images/keyboard/Logitech%2520G513.jpg": "06aad9074f36b6676eb852473e24178a",
"assets/assets/images/keyboard/Logitech%2520G915.jpg": "6a70a154ce6db9ef24e2fce3e46399b7",
"assets/assets/images/keyboard/Razer%2520BlackWidow%2520Elite.jpg": "b98e6ffc76c2764da399f82b38235c58",
"assets/assets/images/keyboard/Razer%2520Cynosa%2520V2.jpg": "132237d2532115c39f8d1475aa15a76a",
"assets/assets/images/keyboard/Razer%2520Huntsman%2520Elite.jpg": "d796828a10572f11762300379a3c555c",
"assets/assets/images/keyboard/SteelSeries%2520Apex%25207.jpg": "3fb67713d42b3ec34239e5eb0a34a643",
"assets/assets/images/keyboard/SteelSeries%2520Apex%2520Pro.jpg": "b20fbac87b7e7604c968721132a04fe0",
"assets/assets/images/logo.png": "f712dff622c980632ab5c7250d2d85a2",
"assets/assets/images/monitor/Acer%2520Nitro%2520XV272U.jpg": "1f66d725b93eb6531637c21aefc7502b",
"assets/assets/images/monitor/Acer%2520Predator%2520XB273K.jpg": "a3e248c2ae7c80293b515435612c7fcd",
"assets/assets/images/monitor/ASUS%2520ROG%2520Swift%2520PG27UQ.jpg": "bd9b4009fb5b09ff16ea892cf826c8a0",
"assets/assets/images/monitor/ASUS%2520TUF%2520Gaming%2520VG27AQ.jpg": "e2331f901e9f784b7485e097de8f0264",
"assets/assets/images/monitor/Dell%2520Alienware%2520AW2720HF.jpg": "f45d846cf14b65722c1b44ebbbaecbd8",
"assets/assets/images/monitor/Dell%2520UltraSharp%2520U2720Q.jpg": "d5d9d2555f53b84da7abd17c30fee1e1",
"assets/assets/images/monitor/LG%2520UltraGear%252027GL850.jpg": "f31944459efb25550dd67c41ee80fcd8",
"assets/assets/images/monitor/LG%2520UltraGear%252034GN850.jpg": "016d43edbd59fa2e0a7f8fd0df92c9c0",
"assets/assets/images/monitor/Samsung%2520Odyssey%2520G7.jpg": "2d5b18592c583672d2466044945836cd",
"assets/assets/images/monitor/Samsung%2520Odyssey%2520G9.jpg": "fa7b2ab292ca9e35225ed8fb66c25d79",
"assets/assets/images/mouse/Logitech%2520G%2520Pro.jpg": "004d64d816ececc5a190c3b2b720b083",
"assets/assets/images/mouse/Logitech%2520G502.jpg": "dac0a871005bd923a1427dd780b71612",
"assets/assets/images/mouse/Logitech%2520G903.jpg": "f61f6088494d08605d488afd8279757f",
"assets/assets/images/mouse/Logitech%2520MX%2520Master%25203.jpg": "086d255eefb2edaa04332bbcd8868791",
"assets/assets/images/mouse/Razer%2520DeathAdder%2520V2.jpg": "d8cbfe1a836bf0163ff07c6e5e52292e",
"assets/assets/images/mouse/Razer%2520Naga%2520Trinity.jpg": "3db94aa236bb98e8d37303ea4a8ec7ec",
"assets/assets/images/mouse/Razer%2520Viper%2520Ultimate.jpg": "8c9e0e54364d15336a029a2027a068a9",
"assets/assets/images/mouse/SteelSeries%2520Aerox%25203.jpg": "785ac7ff478aa0b6d33cf16a7d809f56",
"assets/assets/images/mouse/SteelSeries%2520Rival%2520600.jpg": "353bf421668d556e9239ce540e8528b8",
"assets/assets/images/mouse/steelSeries%2520Sensei%2520310.jpg": "dc1840dc09978970d3656a304e142191",
"assets/assets/images/power/850.jpg": "7163707a2e2f6f3335084e0b6e6b35cb",
"assets/assets/images/power/consair%2520rm%2520750.jpg": "4e675c758696a024afdfbe9082cf765f",
"assets/assets/images/power/consair%2520rm%2520850.jpg": "8e7446a86bbdd0ed0dc6ad3248ce58dc",
"assets/assets/images/power/Cooler%2520Master%2520MWE%2520850.jpg": "5cb7717fb225ff482a3fec8706e55871",
"assets/assets/images/power/coolermaster%2520mwe%2520750.jpg": "2b65c22fcf593481632cb6e656fe6d5c",
"assets/assets/images/power/Corsair%2520RM1000.jpg": "790117ee7727f044c055afaecfb2f596",
"assets/assets/images/power/EVGA%2520SuperNOVA%25201000.jpg": "5eb0dc6f9091083865e4fdd93470e8b0",
"assets/assets/images/power/evga%2520supernova%2520750.jpg": "9a67718871f0a7366ef606f6ddad260f",
"assets/assets/images/power/seasonic%2520focus.jpg": "ab9f04ef09aa6093322d69955d76a0b8",
"assets/assets/images/Ram/consair%252016.jpg": "9d2fbf214e3f8a9954913ea24b11868f",
"assets/assets/images/Ram/crucial%2520ballistix.jpg": "705f3b88b082e09d83ff6c3d9d9d2268",
"assets/assets/images/Ram/gskill%2520z%252016.jpg": "ebff97a9869ea6d017558d0225daa07f",
"assets/assets/images/Ram/kingston%2520hyper%252016.jpg": "c6b46d89907fc344ed6796fb7c4819fd",
"assets/assets/images/Ram/samsung%252016.jpg": "2be106728e73540b8a4904080b7edf06",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "0406168f6efde0f92a709ed7252e2249",
"assets/NOTICES": "df7b7bbf00c514b1a83d438e6a3cf5c4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "d16588f82535d0d930dbb38fdc80167c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9d041630b331dd7e7a3c091f7fdece72",
"/": "9d041630b331dd7e7a3c091f7fdece72",
"main.dart.js": "fbc5ff7ad37702acf1d89a4ff7ba52b5",
"manifest.json": "2b975af08bdc304074019f81b63514f3",
"version.json": "49d08992c30fd42f90b8618c3e31b29d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
