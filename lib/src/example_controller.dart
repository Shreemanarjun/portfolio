import 'package:vaden/vaden.dart';

@Controller("/")
class ExampleController {
  @Get("/")
  Future<Response> index(@Query('name') String? name) async {
    if (name == null) {
      return Response.ok("Hello, World!");
    }
    return Response.ok("Hello,$name");
  }
}
