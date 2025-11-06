extension DateTimeFormat on DateTime{
  String formatted(){
    return '${this.year}.${month}.${day} ${hour}:${minute}';
  }
}

void main() {
  print(DateTime.now().formatted);
}
