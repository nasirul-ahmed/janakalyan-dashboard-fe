import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/collector_model.dart';
import 'package:janakalyan_admin/screen/collector/collection_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CollectorDetails extends StatelessWidget {
  const CollectorDetails({Key? key}) : super(key: key);

  Future<List<Collector>> getCollector() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/collectors-list');
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<Collector>((json) => Collector.fromJson(json))
            .toList();
      }
      return List<Collector>.empty();
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Collectors"),
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constriants) {
         if(constriants.maxWidth > 500){
          return Container(
            width: MediaQuery.of(context).size.width*0.7,
            child: DeskTopBody(getCollector: getCollector,),);
         } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: DeskTopBody(getCollector: getCollector,),);
         }
        }),
      ),
    );
  }
}

class DeskTopBody extends StatelessWidget {
  const DeskTopBody({Key? key, required this.getCollector }) : super(key: key);
  final Function getCollector;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Collector>>(
      future: getCollector(),
      builder: (context, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text("No Collectors"),
          );
        } else if (snap.hasData) {
          return ListView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (_, id) {
                return LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth > 500) {
                    return DeskTopListTile(
                      snap: snap.data![id],
                    );
                  } else {
                    return MobileListTile(
                      snap: snap.data![id],
                    );
                  }
                });
              });
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}

class DeskTopListTile extends StatelessWidget {
  const DeskTopListTile({Key? key, required this.snap}) : super(key: key);

  final Collector snap;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 16,
    );
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CollectionDetails(
                collector: snap,
              ),
            ),
          );
        },
        // style: new ListTileTheme(selectedColor: Colors.white,),

        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(snap.name),
        subtitle: Text("Collector Code: ${snap.id}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Deposit Collection Rs. ${snap.totalCollection}",
              style: style,
            ),
            Text(
              "Loan Collection Rs. ${snap.totalLoanCollection}",
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

class MobileListTile extends StatelessWidget {
  const MobileListTile({Key? key, required this.snap}) : super(key: key);

  final Collector snap;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 16,
    );
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CollectionDetails(
                collector: snap,
              ),
            ),
          );
        },
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(snap.name),
        subtitle: Text("CC: ${snap.id}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "D.C. ${snap.totalCollection}",
              style: style,
            ),
            Text(
              "L.C. ${snap.totalLoanCollection}",
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
