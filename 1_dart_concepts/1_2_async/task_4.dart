import 'dart:isolate';

Future<String> calc(int n) async {
  final receivePort = ReceivePort();

  await Isolate.spawn(_sumNums, [n, receivePort.sendPort]);

  final result = await receivePort.first;

  return result.toString();
}

void _sumNums(List<dynamic> args){
  final int n = args[0];
  final SendPort sendPort = args[1];

  int result = 0;
  for(int i = 1; i < n; i++){
    if(_isPrime(i)) result += i;
  }

  sendPort.send(result);
}

bool _isPrime(int num){
  if(num < 2) return false;
  for(int i = 2; i * i <= num; i++){
    if(num % i == 0) return false;
  }

  return true;
}

void main() async {
  print('Sum of 1 to 15: ${await calc(15)}');
}
