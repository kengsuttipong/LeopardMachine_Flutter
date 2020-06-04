import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';

class MachineFixedInform extends StatefulWidget {
  @override
  _MachineFixedInformState createState() => _MachineFixedInformState();
}

class _MachineFixedInformState extends State<MachineFixedInform> {
  List<MachineModel> _machines = List<MachineModel>();
  List<MachineModel> _machinesForDisplay = List<MachineModel>();
  String tabType;
  bool isrefresh = false;

  @override
  void initState() {
    super.initState();
    readDataMachineListView().then((value) {
      setState(() {
        _machines.addAll(value);
        _machinesForDisplay = _machines;
      });
    });
  }

  Future<List<MachineModel>> readDataMachineListView() async {
    print('read me');
    String url =
        '${MyConstant().domain}/LeopardMachine/getMachineListView.php?isAdd=true';
    var response = await http.get(url);
    var machines = new List<MachineModel>();
    var machineList = json.decode(response.body);
    machines.clear();
    for (var machinesJson in machineList) {
      machines.add(MachineModel.fromJson(machinesJson));
    }

    return machines;
  }

  Future<Null> _refresh() {
    return readDataMachineListView().then((_user) {
      setState(() {
        _machinesForDisplay = _user;
        _machines = _user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text('แจ้งซ่อมเครื่องจักร'),
              bottom: TabBar(
                indicatorColor: Colors.yellow,
                indicatorWeight: 7.0,
                tabs: [
                  Tab(text: 'พร้อมใช้งาน'),
                  Tab(text: 'รอซ่อม'),
                  Tab(text: 'ซ่อมเสร็จแล้ว'),
                ],
              ),
            ),
            body: TabBarView(children: [
               _availableMachine(true),
              _holdingMaintenance(true),
              _maintenanceSuccessed(true),
            ])));
  }

  _availableMachine(isrefresh) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh();
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('1');
          if (isrefresh){
            readDataMachineListView();
          }
          isrefresh = false;
          return index == 0
              ? _searchBar()
              : _listMachineItems(context, index - 1, 'availableMachine', MyStyle().green400);
        },
      ),
    );
  }

  _holdingMaintenance(isrefresh) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh();
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('2');
          if (isrefresh){
            readDataMachineListView();
          }
          isrefresh = false;
          return index == 0
              ? _searchBar()
              : _listMachineItems(context, index - 1, 'holdingMaintenance', MyStyle().red400);
        },
      ),
    );
  }

  _maintenanceSuccessed(isrefresh) {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh();
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('3');
          if (isrefresh) {
            readDataMachineListView();
          }
          isrefresh = false;
          return index == 0
              ? _searchBar()
              : _listMachineItems(context, index - 1, 'maintenanceSuccessed', MyStyle().yellow800);
        },
      ),
    );
  }

  _listMachineItems(context, index, tabType, typeColor) {
    return Card(
      borderOnForeground: true,
      child: ListTile(
        leading: CircleAvatar(
          radius: 28.0,
          backgroundColor: MyStyle().red400,
          backgroundImage: NetworkImage(_machinesForDisplay[index].imageUrl ==
                  null
              ? '${MyConstant().domain}' +
                  '/' +
                  _machinesForDisplay[index].imageUrl
              : '${MyConstant().domain}' + _machinesForDisplay[index].imageUrl),
        ),
        title: Text(
          _machinesForDisplay[index].machineCode,
          style: TextStyle(
            color: typeColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ชื่อเครื่อง : ' + _machinesForDisplay[index].machineName),
            Text('วันซ่อมบำรุงครั้งต่อไป : ' +
                _machinesForDisplay[index].appointmentDate),
          ],
        ),
        onTap: () {
          print('Tab');
        },
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          labelText: 'ค้นหาเครื่องจักร',
          fillColor: MyStyle().red400,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().red400)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().red400)),
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _machinesForDisplay = _machines.where((machine) {
              var machineTitle = machine.machineName.toLowerCase() +
                  machine.machineCode.toLowerCase() +
                  machine.appointmentDate;
              return machineTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }
}