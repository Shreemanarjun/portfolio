import 'package:vaden/vaden.dart';

@Api(
  tag: "ROOT",
  description: "Root API",
)
@Controller("/")
class InitalController {
  @Get()
  Future<Response> getRoot() async {
    return Response.ok(
      "Welcome to Portfolio",
    );
  }
}
