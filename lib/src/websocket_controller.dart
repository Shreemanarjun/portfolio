import 'dart:async';

import 'package:vaden/vaden.dart';

import '../config/websocket/websocket_resource.dart';

@Controller('/chat')
class ChatController extends WebSocketResource {
  @Mount('/')
  FutureOr<Response> webSocketHandler(Request request) {
    return handler(request);
  }

  @override
  void connect(socket) {
    socket.emit('SERVER: New client connected!');
  }

  @override
  void onMessage(covariant String data, socket) {
    if (data.startsWith('@enterroom ')) {
      final room = data.replaceFirst('@enterroom ', '');
      socket.joinRoom(room);
      socket.sink.add('You entered room $room');
      socket.emit('ROOM: New client connected', [room]);
    } else if (data.startsWith("@getRooms")) {
      print("Data:$data rooms:${socket.enteredRooms}");
      socket.emit({
        "data_type": "user_result",
        "data": {
          {
            'MESSAGE': data,
            'NAME': 'Server',
            'DATE': DateTime.now().toString(),
          }
        }
      });
    } else if (data.startsWith('@leaveroom ')) {
      final room = data.replaceFirst('@leaveroom ', '');
      socket.sink.add('You left room $room');
      socket.leaveRoom(room);
      socket.emit('ROOM: Client left the room', [room]);
    } else if (data.startsWith('@changename ')) {
      final name = data.replaceFirst('@changename ', '');
      socket.emitToRooms('${socket.tag} changed their name to $name');
      socket.sink.add('Your new name is $name');
      socket.tag = name;
    } else if (socket.enteredRooms.isNotEmpty) {
      socket.emitToRooms('${socket.tag}: $data');
    } else {
      socket.sink.add('Please enter a room to chat');
    }
  }

  @override
  void disconnect(socket) {
    socket.emit('SERVER: Client disconnected');
  }
}
