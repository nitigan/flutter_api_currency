import 'dart:convert';
import 'currency_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Currency>> fetchData(String code) async {
    List<String> codes = ['usd', 'thb', 'aud', 'gbp', 'jpy', 'cny'];
    http.Response response =
        await http.get('http://www.floatrates.com/daily/$code.json');

    var jsonObject = jsonDecode(response.body);

    List<Currency> _currencies = [];
    codes.forEach((element) {
      if (element != code)
        _currencies.add(Currency.fromJson(jsonObject[element]));
    });
    setState(() {});
    return _currencies;
  }

  Future<List<Currency>> currencies;
  String fromCode;
  String fromName;
  String fromFlag = 'https://flagcdn.com/64x48/cn.png';
  @override
  void initState() {
    super.initState();
    fromCode = 'cny';
    currencies = fetchData(fromCode);
    fromName = 'China';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Exchange rate'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[800],
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              leading: Image.network(fromFlag),
              title: Text(
                fromName,
                style: TextStyle(fontSize: 25.0),
              ),
              subtitle: Text(
                '1',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Text('tap on a currency to make it the source: '),
          //Text('$fromName to:',style: TextStyle(fontSize: 25.0),),
          FutureBuilder(
            future: currencies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Currency> cur = snapshot.data;
                if (cur.isEmpty) {
                  return SpinKitWave(
                    color: Colors.black,
                    size: 50,
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: cur.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.blue,
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            fromName = cur[index].name;
                            fromCode = cur[index].code;
                            fromFlag = cur[index].flag;
                            cur.clear();
                            setState(() {});
                            currencies = fetchData(fromCode.toLowerCase());
                          },
                          leading: Image.network(cur[index].flag),
                          title: Text(
                            cur[index].name,
                            style: TextStyle(fontSize: 25.0),
                          ),
                          subtitle: Text(
                            '${cur[index].rate}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return SpinKitWave(
                  color: Colors.lightBlue,
                  size: 50,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
