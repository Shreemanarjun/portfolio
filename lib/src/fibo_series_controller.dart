import 'package:vaden/vaden.dart';

@Api(tag: 'Fibo', description: 'FiboSeriesController')
@Controller("/fibo")
class FiboSeriesController {
  @Get('/fibonacci')
  Future<String> getFibonacciSeries(@Query('n') int n) async {
    if (n == null) {
      return "Please provide a number";
    }
    List<int> fiboSeries = [0, 1];
    while (fiboSeries.last < n) {
      fiboSeries.add(
        fiboSeries.last + fiboSeries.last - fiboSeries[0],
      ); // This line is the key to the Fibonacci series
    }
    return fiboSeries.toString();
  }
}
