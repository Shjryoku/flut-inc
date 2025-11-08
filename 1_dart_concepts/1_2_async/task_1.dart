import 'dart:async';

class Debouncer<T> {
  final Duration delay;
  Timer? _timer;

  Debouncer(this.delay);

  void call(void Function(T value) action, T value){
    _timer?.cancel;
    _timer = Timer(delay, () => action(value));
  }
}

class Chat {
  Chat(this.onRead);

  final void Function(int message) onRead;
  final _debouncer = Debouncer(Duration(milliseconds: 1000));

  final List<int> messages = List.generate(30, (i) => i);

  void read(int message) {
    if(!messages.contains(message)){
      print('No message');
      return;
    }

    _debouncer((msg) => onRead!(msg), message);
  }
}

Future<void> main() async {
  final Chat chat = Chat((i) => print('Read until $i'));

  chat.read(0);

  await Future.delayed(Duration(milliseconds: 1000));

  chat.read(4);
  await Future.delayed(Duration(milliseconds: 100));
  chat.read(10);
  await Future.delayed(Duration(milliseconds: 100));
  chat.read(11);
  await Future.delayed(Duration(milliseconds: 100));
  chat.read(12);
  await Future.delayed(Duration(milliseconds: 100));
  chat.read(13);
  await Future.delayed(Duration(milliseconds: 100));
  chat.read(14);
  await Future.delayed(Duration(milliseconds: 100));

  chat.read(15);

  await Future.delayed(Duration(milliseconds: 1000));

  chat.read(20);

  await Future.delayed(Duration(milliseconds: 1000));

  chat.read(35);
  await Future.delayed(Duration(milliseconds: 100));
  chat.read(36);
  await Future.delayed(Duration(milliseconds: 500));
  chat.read(37);
  await Future.delayed(Duration(milliseconds: 800));

  chat.read(40);
}
