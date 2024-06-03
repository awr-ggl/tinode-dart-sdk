import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tinode/src/models/message-status.dart' as message_status;
import 'package:tinode/src/models/packet-types.dart' as packet_types;
import 'package:tinode/src/services/packet-generator.dart';
import 'package:tinode/src/models/packet-data.dart';
import 'package:tinode/src/models/packet.dart';

class MessageDraftyReply {
  bool echo;
  int? _status;
  DateTime? ts;
  String? from;
  bool? cancelled;
  dynamic head;
  dynamic content;
  String? topicName;
  bool? noForwarding;

  late PacketGenerator _packetGenerator;

  PublishSubject<int> onStatusChange = PublishSubject<int>();

  MessageDraftyReply(this.topicName, this.head, this.content, this.echo) {
    _status = message_status.NONE;
    _packetGenerator = GetIt.I.get<PacketGenerator>();
  }

  Packet asPubPacket() {
    var packet = _packetGenerator.generate(packet_types.Pub, topicName);
    var data = packet.data as PubPacketData;
    data.head = head;
    data.content = content;
    data.noecho = !echo;
    packet.data = data;
    return packet;
  }

  void setStatus(int status) {
    _status = status;
    onStatusChange.add(status);
  }

  int? getStatus() {
    return _status;
  }

  void resetLocalValues() {
    ts = null;
    setStatus(message_status.NONE);
  }
}
