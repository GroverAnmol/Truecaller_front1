import 'package:flutter/cupertino.dart';
import 'package:untitled37/screens/call_log_details_screen.dart';
import 'package:untitled37/widgets/call_log_item.dart';
import 'package:flutter/material.dart';
import 'package:untitled37/helpers.dart';
import 'package:call_log/call_log.dart';

import '../custom_colors.dart';
import '../widgets/drawer.dart';

class RecentsCallLogScreen extends StatefulWidget {
  const RecentsCallLogScreen({super.key});
  @override
  State<RecentsCallLogScreen> createState() => _RecentsCallLogScreenState();
}

class _RecentsCallLogScreenState extends State<RecentsCallLogScreen>
    with WidgetsBindingObserver {
  late Future<Iterable<CallLogEntry>> allCallLogs;
  TextEditingController _searchController = TextEditingController();
  List<CallLogEntry> entries = [];
  List<CallLogEntry> filteredEntries = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    allCallLogs = getAllCallLogs();
    _searchController.addListener(() {
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        allCallLogs = getAllCallLogs();
      });
    }
  }

  void _onClickInfo(BuildContext context, CallLogEntry callLog) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => CallLogDetailsScreen(callLog: callLog),
        ));
  }
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchController.text.isNotEmpty;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWid(),
        appBar: AppBar(
          backgroundColor: Color(appBarColor),
          title: const Text('Recents'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    label: Text(
                      'Search',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: allCallLogs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<CallLogEntry> entries = snapshot.data!.toList();

                      return ListView.builder(
                        itemCount: isSearching == true ? null : entries.length,
                        itemBuilder: (context, index) => CallLogItem(
                            currentCallLog: isSearching == true ? null : entries.elementAt(index),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}