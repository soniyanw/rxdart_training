import 'dart:async';

import 'package:rxdart/rxdart.dart';

filter() {
  RangeStream(0, 6)
      .where((event) => event > 2 && event < 6)
      .listen(print, onDone: () => print('Filter'));
  //3,4,5 //filters items based on a condition
}

map() async {
  Stream.fromIterable([1, 2, 3, 4, 5, 6])
      .map((event) => event * 2)
      .listen(print, onDone: () => print('Map'));
  //2,4,6,8,10,12 //performs an operation on each item
}

flatmap() {
  Stream.fromIterable([1, 2, 3, 4, 5, 6])
      .interval(Duration(seconds: 1))
      .flatMap((i) => TimerStream(i + 2, Duration(seconds: 4)))
      .listen(print);
  //3,4,5,6,7,8
}

concatmap() {
  Stream.fromIterable([1, 2, 3, 4, 5, 6])
      .interval(Duration(seconds: 1))
      .concatWith([
    Stream.fromIterable([1, 2, 3, 4, 5, 6])
  ]).listen(print);
  //concatenates two streams
}

concat() {
  ConcatStream([
    Stream.fromIterable([1]),
    Stream.fromIterable([2, 5]),
    Stream.fromIterable([4, 3, 6]),
  ]).listen(print, onDone: () => print('Concat'));
  //1,2,5,4,3,6 //one after other
}

combinelatest() {
  CombineLatestStream.list<int>([
    Stream.fromIterable([2, 1, 5, 6]),
    Stream.fromIterable([6, 7, 3, 8, 9]),
  ]).listen(print, onDone: () => print('Combine'));
  //order 2  1  5  6
  //       6  7  3  8  9
  //output 26 16 17 57 53 63 68 69
}

zip() {
  ZipStream.list<int>([
    Stream.fromIterable([2, 3]),
    Stream.fromIterable([6, 7, 3, 8, 9]),
  ]).listen(print);
  //order 2  3
  //       6  7  3  8  9
  //output 26 (62 cannot) (36 cannot) 37 (others cannot)
}

scan() {
  Stream.fromIterable([1, 2, 3, 4, 5])
      .scan((acc, curr, i) => (acc as int) + curr, 0)
      .listen(print);
  // output 1, 3, 6,10,15
  //stream 1  2  3   4  5
  //         1  3  6  10  15
}

reduce() async {
  final aa = await Stream.fromIterable([1, 2, 3, 4, 5])
      .reduce((previous, element) => previous * element);
  print(aa);
  print("Reduce");
  // output= 1*2*3*4*5=120
}

debounce() {
  Stream.fromIterable([1, 2, 3, 4])
      .debounceTime(Duration(seconds: 1))
      .listen(print, onDone: () => print('Debounce'));
  //all inputs without time gap
  //only 4 will be output
  //1 emits ,within 1 sec, 2 comes,so 1 is debounced ....similarly....
  Stream.fromIterable([1, 2, 3, 4])
      .interval(Duration(seconds: 2))
      .debounceTime(Duration(seconds: 1))
      .listen(print, onDone: () => print('Debounce'));
  //inputs with proper time gap
  //all elements emitted with 2 sec time gap
  //output 1 2 3 4 with 2 sec timegap
}

distinct() {
  Stream.fromIterable([1, 2, 3, 4, 4, 3, 3, 4, 6, 5])
      .distinctUnique()
      .listen(print, onDone: () => print('Distinct'));
  //output 1,2,3,4,5,6
  //only unique items
}

distinctuntilchanged() {
  Stream.fromIterable([1, 2, 3, 3, 4, 4, 3, 4, 4, 6, 5])
      .distinct()
      .listen(print, onDone: () => print('DistinctUntilChanged'));
  //output 1,2,3,4,3,4,6,5
  //emits if the previous item is not same as the one to be emitted
}

takeuntil() {
  MergeStream([
    Stream.fromIterable([
      1,
      2,
      3,
      4,
    ]),
    TimerStream(11, Duration(seconds: 2))
  ]).takeUntil(TimerStream(3, Duration(seconds: 5))).listen(print);
  //1,2,3,4,11
  //merges before takeuntil starts
  MergeStream([
    Stream.fromIterable([
      1,
      2,
      3,
      4,
    ]),
    TimerStream(11, Duration(seconds: 8))
  ]).takeUntil(TimerStream(3, Duration(seconds: 5))).listen(print);
  //1,2,3,4
  //11 not added as takeuntil executed before it could merge
}

defIfEmpty() {
  Stream.fromIterable([])
      .defaultIfEmpty(5)
      .listen(print, onDone: () => print("Default if Empty"));
  //output 5
  //stream is empty hence default value is taken
}
