// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background/flutter_background.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// typedef RouteCallback = void Function(BuildContext context);

// class RouteItem {
//   RouteItem({
//     required this.title,
//     this.subtitle,
//     this.push,
//   });

//   final String title; //declaration
//   final String? subtitle;//可空性（nullability）
//   final RouteCallback? push;
// }

// void checkPlatform() {
//   if (WebRTC.platformIsDesktop) {
//     debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   } else if (WebRTC.platformIsAndroid) {
//     WidgetsFlutterBinding.ensureInitialized();
//     startForegroundService();
//   }
// }

// void _initItems() {
//   items = <RouteItem>[
//     RouteItem(
//         title: 'GetUserMedia',
//         push: (BuildContext context) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => GetuserMediaSample()));
//         })
//   ];
// }

// Future<bool> startForegroundService() async {
//   final androidConfig = FlutterBackgroundAndroidConfig(
//     notificationTitle: 'Title',
//     notificationText: 'text',
//     notificationImportance: AndroidNotificationImportance.Default,
//     notificationIcon:
//         AndroidResource(name: 'background_icon', defType: 'drawable'),
//   );
//   await FlutterBackground.initialize(androidConfig: androidConfig);
//   return FlutterBackground.enableBackgroundExecution();
// }

// class Webrtc extends StatefulWidget {
//   const Webrtc({super.key});

//   @override
//   State<Webrtc> createState() => _WebrtcState();
// }

// class _WebrtcState extends State<Webrtc> {
//   late List<RouteItem> items;

//   @override
//   void iniState() {
//     super.initState();
//     _initItems();
//   }

//   ListBody _buildRow(context, item) {
//     return ListBody(children: <Widget>[
//       ListTile(
//         title: Text(item.title),
//         onTap: () => item.push(context),
//         trailing: Icon(Icons.arrow_right),
//       ),
//       Divider()
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           appBar: AppBar(
//             title: Text('FLutter-WebRTC example'),
//           ),
//           body: ListView.builder(
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(0.0),
//             itemCount: items.length,
//             itemBuilder: (context, i) {
//               return _buildRow(context, items[i]);
//             },
//           ),
//         ));
//   }
// }
