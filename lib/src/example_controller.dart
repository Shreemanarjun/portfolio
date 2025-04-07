import 'package:vaden/vaden.dart';

@Api(tag: 'Example', description: 'ExampleController')
@Controller("/example")
class ExampleController {
  @Get("/hello")
  Future<Response> helo(@Query('name') String? name) async {
    if (name == null) {
      return Response.ok("Hello, World!");
    }
    return Response.ok("Hello,$name");
  }
}
