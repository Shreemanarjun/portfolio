import 'dart:io';

import 'package:vaden/vaden.dart';

@Api(
  tag: "ROOT",
  description: "Root API",
)
@Controller("/")
class InitalController {
  final ResourceService resource;
  final Storage storage;

  InitalController({required this.resource, required this.storage});
  @Get()
  Future<Response> getRoot(
    Request request,
  ) async {
    final currentPath = Directory.current.path;
    final index = await File("$currentPath/public/index.html").readAsString();
    return Response.ok(
      index,
      headers: {
        "Content-Type": "text/html",
      },
    );
  }
}
