import 'package:tinode/tinode.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

// void main(List<String> args) async {
//   var key = 'AQEAAAABAAD_rAp4DJh05a1HAwFT3A6K';
//   var host = 'chat-demo.ggl.life';

//   var loggerEnabled = true;
//   var tinode = Tinode(
//       'Moein', ConnectionOptions(host, key, secure: true), loggerEnabled);
//   await tinode.connect();
//   print('Is Connected:' + tinode.isConnected.toString());
//   var result = await tinode.loginBasic('ariesfreey', '12345678', null);
//   print('User Id: ' + result.params['user'].toString());

//   var me = tinode.getMeTopic();
//   me.onSubsUpdated.listen((value) {
//     for (var item in value) {
//       print('Subscription[' +
//           item.topic.toString() +
//           ']: ' +
//           ' - Unread Messages:' +
//           item.unread.toString());
//     }
//   });
//   await me.subscribe(MetaGetBuilder(me).withLaterSub(null).build(), null);

//   var grp = tinode.getTopic('grpeTeKuPsh0Vw');
//   grp.onData.listen((value) {
//     if (value != null) {
//       print('DataMessage: ' + value.content);
//     }
//   });

//   await grp.subscribe(
//       MetaGetBuilder(tinode.getTopic('grpeTeKuPsh0Vw'))
//           .withLaterSub(null)
//           .withLaterData(null)
//           .build(),
//       null);
//   var msg = grp.createMessage('This is cool', false);
//   await grp.publishMessage(msg);
// }

// MR Frendhi Experiment => use chain flow from start and same grp topic
void main(List<String> args) async {
  StreamController<String> inputController = StreamController<String>();
  // Listen for user input and add it to the stream.
  stdin
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .listen((String line) => inputController.add(line));

  print(args);
  var key = 'AQEAAAABAAD_rAp4DJh05a1HAwFT3A6K';
  var host = 'chat-demo.ggl.life';
  var grpID = 'grppQw179RgniM';

  var loggerEnabled = true;
  var tinode = Tinode(
      'Moein', ConnectionOptions(host, key, secure: true), loggerEnabled);
  await tinode.connect();
  print('Is Connected:' + tinode.isConnected.toString());
  var result = await tinode.loginBasic('1684426476GC20gy', '67or05ka', null);
  print('User Id: ' + result.params['user'].toString());

  var me = tinode.getMeTopic();
  me.onSubsUpdated.listen((value) {
    for (var item in value) {
      print('Subscription[' +
          item.topic.toString() +
          ']: ' +
          ' - Unread Messages:' +
          item.unread.toString());
    }
  });
  await me.subscribe(MetaGetBuilder(me).withLaterSub(null).build(), null);

  var grp = tinode.getTopic(grpID);
  grp.onData.listen((value) {
    print('Value: $value'); // Print the value of the variable
    if (value != null) {
      print('DataMessage: ' + value.content.toString());
    }
  });

  await grp.subscribe(
      MetaGetBuilder(tinode.getTopic(grpID))
          .withLaterSub(10)
          .withLaterData(10)
          .build(),
      null);
  var msg = grp.createMessage('PUB', true);
  await grp.publishMessage(msg);
  // Listen for new events on the stream.
  inputController.stream.listen((String line) async {
    // Handle the input...
    print('Input: $line');

    if (tinode.isConnected) {
      var msg = grp.createMessage(line, true);
      await grp.publishMessage(msg);
    } else {
      await tinode.connect();
      print('Is Connected:' + tinode.isConnected.toString());
      var result =
          await tinode.loginBasic('1684426476GC20gy', '67or05ka', null);
      print('User Id: ' + result.params['user'].toString());
      if (tinode.isConnected) {
        var msg = grp.createMessage(line, true);
        await grp.publishMessage(msg);
      } else {
        print('Failed to connect and login.');
      }
    }
  });
}
