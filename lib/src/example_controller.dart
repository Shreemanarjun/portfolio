import 'package:vaden/vaden.dart';

@Api(tag: 'Example', description: 'ExampleController')
@Controller("/example")
class ExampleController {
  @Get("/hello")
  Future<Response> helo(@Query('name') String? name) async {
    if (name == null) {
      return Response.ok(
        "Hello, World!",
      );
    }
    return Response.ok("Hello,$name");
  }

  @Get("/stream")
  Future<Response> streamNumbers() async {
    final stream =
        Stream.periodic(const Duration(milliseconds: 100), (i) => i + 1)
            .take(100); // take only the first 100 numbers

    return Response.ok(
      stream.map((number) => '$number\n'.codeUnits),
      context: {"shelf.io.buffer_output": false},

      // convert each number to a Stream<List<int>>
    );
  }
}
