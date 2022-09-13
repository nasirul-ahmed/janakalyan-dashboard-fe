import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/screen/drawer/drawer.dart';
import 'package:janakalyan_admin/screen/login.dart';
import 'package:janakalyan_admin/services/todays_collection/todays_collection.dart';
import 'package:janakalyan_admin/widgets/account_list.dart';
import 'package:janakalyan_admin/widgets/right_panel.dart';
import 'package:janakalyan_admin/widgets/right_panel_mobile.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  TodayCollection x = TodayCollection();
  int reload = 1;

  handleClick() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            // pw.Center(
            //   child: pw.Text("Header"),
            // ),
            pw.Partition(child: pw.Column(children: [pw.Text("hello")])),
          ]); // Center
        }));
    Uint8List pdfInBytes = await pdf.save();

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'pdf.pdf'
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    print(reload.toString());
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          MaterialButton(
            onPressed: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setBool("isLogged", false);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: reload > 0
          ? LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    // MediaQuery.of(context).size.width
                    AccountList(),
                    const SizedBox(
                      width: 10,
                    ),
                    RightPanel(reload: reload),
                  ],
                );
              } else {
                return Expanded(
                  child: Center(
                    child: RightPanelDeskTop(
                      reload: reload,
                    ),
                  ),
                );
              }
            })
          : const SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            reload++;
          });
        },
        // label: Text("$reload"),
        child: const Icon(Icons.replay_outlined),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
