import 'package:tinode/tinode.dart';

void main(List<String> args) async {
  var key = 'AQEAAAABAAD_rAp4DJh05a1HAwFT3A6K';
  var host = 'chat-demo.ggl.life';

  var loggerEnabled = true;
  var tinode = Tinode(
      'Moein', ConnectionOptions(host, key, secure: true), loggerEnabled);
  await tinode.connect();
  print('Is Connected:' + tinode.isConnected.toString());
  var result = await tinode.loginBasic('ariesfreey', '12345678', null);
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

  var grp = tinode.getTopic('grpeTeKuPsh0Vw');
  grp.onData.listen((value) {
    if (value != null) {
      print('DataMessage: ' + value.content);
    }
  });

  await grp.subscribe(
      MetaGetBuilder(tinode.getTopic('grpeTeKuPsh0Vw'))
          .withLaterSub(null)
          .withLaterData(null)
          .build(),
      null);
  var msg = grp.createMessage('This is cool', false);
  await grp.publishMessage(msg);
}
