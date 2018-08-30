import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue[800],
  primaryColor: Colors.green[100],
);

const String timeHolder = "9AM";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Journal Days",
      theme: defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      home: new Entry(),
    );
  }

}

class Entry extends StatefulWidget {
  @override
  State createState() => new EntryWindow();
}

class EntryWindow extends State<Entry> with TickerProviderStateMixin {
  final List<MiniEntry> _entries = <MiniEntry>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Put Date Here?"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: new Column(children: <Widget>[
        new Flexible(child: new ListView.builder(
          itemBuilder: (_, int index) => _entries[index],
          itemCount: _entries.length,
          reverse: true,
          padding: new EdgeInsets.all(6.0)
        )),
        new Divider(height: 1.0),
        new Container(
          child: _buildComposer(),
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        )
      ]),
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal:  9.0),
            child:new Row(
              children: <Widget>[
                new Flexible(child: new TextField(
                  controller: _textController,
                  onChanged: (String txt){
                    setState((){
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitEntry,
                  decoration: new InputDecoration.collapsed(hintText: "What did you do today?"),
                ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Log"),
                      onPressed: _isWriting ? () => _submitEntry(_textController.text)
                          : null
                  )
                  : new IconButton(
                      icon: new Icon(Icons.message),
                      onPressed: _isWriting
                          ? () => _submitEntry(_textController.text)
                          : null,
                      )
                  ),
              ],
            ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(
            border:
              new Border(top: new BorderSide(color: Colors.brown[200]))) : null
          ),

    );

}

void _submitEntry(String txt){
  _textController.clear();
  setState((){
    _isWriting = false;
  });

  MiniEntry entry = new MiniEntry(
    txt: txt,
      animationController: new AnimationController(
          vsync: this,
        duration: new Duration(milliseconds: 800)
      ),
  );

  setState(() {
    _entries.insert(0, entry);
  });
  entry.animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (MiniEntry entry in _entries){
      entry.animationController.dispose();
    }
    super.dispose();
  }
}

class MiniEntry extends StatelessWidget{
  MiniEntry({this.txt, this.animationController});

  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SizeTransition(sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut),
    axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: new CircleAvatar(child:new Text(timeHolder)),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(timeHolder, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top:6.0),
                    child: new Text(txt),
                  )
                ],
              ),
            )
          ]
        )
      ),
    );
  }

}
