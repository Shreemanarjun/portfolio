import 'dart:async';

import 'package:vaden/vaden.dart';

@Configuration()
class AppConfiguration {
  @Bean()
  ApplicationSettings settings() {
    return ApplicationSettings.load('application.yaml');
  }

  @Bean()
  Pipeline globalMiddleware(ApplicationSettings settings) {
    return Pipeline()
        .addVadenMiddleware(StoreRequestTimeMiddleware())
        .addMiddleware(cors(
          allowedOrigins: ['*', '0.0.0.0', 'http://localhost:8080'],
        ))
        .addVadenMiddleware(EnforceJsonContentType())
        .addMiddleware(logRequests())
        .addVadenMiddleware(CalculateTotalTimeMiddleware());
  }
}

@Component()
class StoreRequestTimeMiddleware extends VadenMiddleware {
  @override
  FutureOr<Response> handler(Request request, Handler handler) async {
    print(
        "requested url path:'${request.handlerPath}' url:'${request.url.path}' isEmpty:'${request.isEmpty}'");
    if (request.handlerPath == "/" &&
        request.url.path == "" &&
        request.method == "GET") {
      return Response.movedPermanently(
        "/docs/",
      );
    }
    final currentTime = DateTime.now();
    final requestWithTime = request.change(headers: {
      ...request.headers,
      'X-Request-Time': currentTime.toIso8601String(),
    });
    return handler(requestWithTime);
  }
}

@Component()
class CalculateTotalTimeMiddleware extends VadenMiddleware {
  @override
  FutureOr<Response> handler(Request request, Handler handler) async {
    final requestTime = DateTime.parse(request.headers['X-Request-Time'] ?? '');
    final response = await handler(request);
    final responseTime = DateTime.now();
    final totalTime = responseTime.difference(requestTime);
    print("Total time taken: ${totalTime.inMilliseconds} ms");
    final responseWithTime = response.change(headers: {
      ...response.headers,
      'X-Server-Requested-Time': "${requestTime} ",
      'X-Server-Responded-Time': "${responseTime} ",
      'X-Server-Response-Time': '${totalTime.inMilliseconds} ms',
    });
    return responseWithTime;
  }
}
