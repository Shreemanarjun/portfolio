import 'package:vaden/vaden.dart';

@DTO()
class PingResponse {
  final String message;
  final String timestamp;

  PingResponse({required this.message, required this.timestamp});
}

@Api(tag: 'Hello', description: 'Hello Controller')
@Controller('/hello')
class HelloController {
  @Get('/ping')
  PingResponse ping() {
    return PingResponse(
      message: 'Hello, World!',
      timestamp: DateTime.now().toString(),
    );
  }
}
