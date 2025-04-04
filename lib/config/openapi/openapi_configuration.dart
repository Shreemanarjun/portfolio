import 'dart:convert';
import 'package:vaden/vaden.dart';
import 'package:vaden/vaden_openapi.dart';
import 'package:openapi_spec/src/open_api/index.dart' as openapi;

@Configuration()
class OpenApiConfiguration {
  @Bean()
  OpenApi openApi(OpenApiConfig config) {
    final server = config.localServer;

    return OpenApi(
      version: '3.0.0',
      info: Info(
        title: 'Vaden API',
        version: '1.0.0',
        description: 'Vaden Backend example',
      ),
      servers: [
        openapi.Server(url: 'https://portfolio.shreeman.dev'),
        server,
      ],
      tags: config.tags,
      paths: config.paths,
      components: Components(
        schemas: config.schemas,
      ),
    );
  }

  @Bean()
  SwaggerUI swaggerUI(OpenApi openApi) {
    return SwaggerUI(
      jsonEncode(openApi.toJson()),
      title: 'portfolio API',
      docExpansion: DocExpansion.full,
      deepLink: true,
      persistAuthorization: true,
      syntaxHighlightTheme: SyntaxHighlightTheme.agate,
      specType: SpecType.json,
    );
  }
}
