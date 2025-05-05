import 'package:portfolio/vaden_application.dart';

Future<void> main(List<String> args) async {
  final vaden = VadenApplicationImpl();
  await vaden.setup();
  final server = await vaden.run(args);

  print(
      'Server listening on port http://${server.address.host}:${server.port}');
  const bool kReleaseMode = bool.fromEnvironment("dart.vm.product");
  print("Release mode $kReleaseMode");
}
