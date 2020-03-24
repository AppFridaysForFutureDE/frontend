import 'package:app/app.dart';

class FilterPage extends StatefulWidget {
  final FilterState state;
  FilterPage(this.state);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  FilterState state;
  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
    );
  }
}

class FilterState {}
