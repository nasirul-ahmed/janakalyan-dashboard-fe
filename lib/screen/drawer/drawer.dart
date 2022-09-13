import 'package:flutter/material.dart';
import 'package:janakalyan_admin/screen/account_transfer/account_transfer.dart';
import 'package:janakalyan_admin/screen/account_transfer/transferred_accounts.dart';
import 'package:janakalyan_admin/screen/add_collector/add_collector.dart';
import 'package:janakalyan_admin/screen/handle_loan/closed_loan_list.dart';
import 'package:janakalyan_admin/screen/hold_accounts_list/hold_accounts.dart';
import 'package:janakalyan_admin/screen/maturity/matured_accounts.dart';
import 'package:janakalyan_admin/screen/under_maturity/under_maturity.dart';
import 'package:janakalyan_admin/widgets/mobile_account_list.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Drawer",
      child: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const InkWell(
            child: SizedBox(
              height: 200,
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                accountEmail: Text('Admin'),
                accountName:
                    Text('janakalyan-ag', style: TextStyle(fontSize: 20)),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.black,
                  //shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'All Deposits Customer',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => MobileAccountList()));
              },
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Under Maturity Accounts',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => UnderMaturity()));
              },
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Matured Accounts',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => MaturedAccounts()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Closed Loans',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ClosedLoans()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Add Collector',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddCollector()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Hold Accounts',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HoldAccounts()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Transfer Account',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AccountTransfer()));
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
          Container(
            //color: Colors.black38,
            decoration: const BoxDecoration(color: Colors.black12),
            child: ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Transferred Accounts',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => TransferredAccounts()));
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
