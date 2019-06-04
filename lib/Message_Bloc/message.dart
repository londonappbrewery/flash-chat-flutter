
class Message {
  String _sender;
  String _text;

  String get sender => _sender;
  String get text => _text;

  Message(this._sender, this._text);

  set sender(val) {
    _sender = val;
  }

  set text(val) {
    _text = val;
  }
}