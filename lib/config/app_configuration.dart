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
        .addMiddleware(cors(
          allowedOrigins: ['*', '0.0.0.0', 'http://localhost:8080'],
        ))
        .addVadenMiddleware(EnforceJsonContentType())
        .addVadenMiddleware(ResponseTiMeMiddleware())
        .addMiddleware(logRequests());
  }
}

@Component()
class ResponseTiMeMiddleware extends VadenMiddleware {
  @override
  FutureOr<Response> handler(Request request, Handler handler) async {
    /// add timer to calculate time to process
    /// and add it to the response

    final startTime = DateTime.now();

    final response = await handler(request);
    final endTime = DateTime.now();
    final timeToProcess = endTime.difference(startTime);
    print("time taken ${timeToProcess.inMilliseconds}");

    final chnagedResponse = response.change(headers: {
      ...response.headers,
      'X-Response-Time': timeToProcess.inMilliseconds.toString() + " ms"
    });
    return chnagedResponse;
  }
}
