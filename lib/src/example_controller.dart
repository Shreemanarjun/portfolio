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

  @Get("/sse")
  @ApiResponse(
    200,
    description: "success stream",
    content: ApiContent(
      type: 'text/event-stream',
    ),
  )
  Future<Response> sseExample() async {
    final stream =
        Stream.periodic(const Duration(milliseconds: 100), (i) => i + 1)
            .take(100) // take only the first 100 numbers
            .map((number) =>
                'data: $number\n'); // convert each number to an SSE event

    return Response.ok(
      stream.map((number) => '$number\n'.codeUnits),
      context: {"shelf.io.buffer_output": false},
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
      },
    );
  }
}
