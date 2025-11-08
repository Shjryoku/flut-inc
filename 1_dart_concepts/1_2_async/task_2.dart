import 'dart:async';
import 'dart:math';

class Server {
  /// [StreamController] simulating an ongoing websocket endpoint.
  StreamController<int>? _controller;

  /// [Timer] periodically adding data to the [_controller].
  Timer? _timer;

  /// Initializes this [Server].
  Future<void> init() async {
    final Random random = Random();

    while (true) {
      _controller = StreamController<int>.broadcast();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _controller?.add(timer.tick);
      });

      // Oops, a crash happened...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );

      // Kill the [StreamController], simulating a network loss.
      _controller?.addError(DisconnectedException());
      _controller?.close();
      _controller = null;

      _timer?.cancel();
      _timer = null;

      // Waiting for server to recover...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );
    }
  }

  /// Returns a [Stream] of data, if this [Server] is up and reachable, or
  /// throws [DisconnectedException] otherwise.
  Future<Stream<int>> connect() async {
    if (_controller != null) {
      return _controller!.stream;
    } else {
      throw DisconnectedException();
    }
  }
}

class DisconnectedException implements Exception {}

class Client {
  bool _connected = false;
  bool _connecting = false;

  final Duration initDelay;
  final Duration maxDelay;
  final int maxRetries;
  final double multiplier;
  final bool useJitter;

  Client({
    this.initDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 30),
    this.maxRetries = 5,
    this.multiplier = 2.0,
    this.useJitter = true,
  });

  Future<void> _tryConnect(int attempt) async {
    final factor = pow(multiplier, attempt - 1).toDouble();
    var delay = Duration(milliseconds: (initDelay.inMilliseconds * factor).round());
    if(delay > maxDelay) delay = maxDelay;
    if(useJitter) delay = _applyJitter(delay);
    await Future.delayed(delay);
  }

  Duration _applyJitter(Duration delay) {
    final jitterFactor = Random().nextDouble();
    return Duration(milliseconds: (delay.inMilliseconds * jitterFactor).round());
  }

  Future<void> connect(Server server) async {
    if(_connected || _connecting) return;
    _connecting = true;

    for(var attempt = 1; attempt <= maxRetries; attempt++){
      try{
        final stream = await server.connect();
        print('Connected');
        _connected = true;
        _connecting = false;

        stream.listen(
          (event) => print('Connected, got: $event'),
            onError: (err) async{
              print('Disconnected. Reconnecting...');
              _connected = false;
              _connecting = false;
              await connect(server);
            },
            cancelOnError: true,
          );
          return;
      } catch(e){
        _connecting = false;
        _connected = false;
        print('Connection failed: $e');
        await _tryConnect(attempt);
      }
    }
    print('Failed to connect after $maxRetries attempts');
    _connecting = false;
  }
}

Future<void> main() async {
  final server = Server();
  unawaited(server.init());
  await Client().connect(server);
}
