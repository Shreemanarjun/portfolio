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
        //.addVadenMiddleware(ResponseTiMeMiddleware())
        .addMiddleware(cors(allowedOrigins: ['*']))
        .addVadenMiddleware(EnforceJsonContentType())
        .addMiddleware(logRequests());
  }
}

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

    return response.change(headers: {
      ...response.headers,
      'X-Response-Time': timeToProcess.inMilliseconds.toString()
    });
  }
}
