class Currency {
  String name;
  String code;
  String flag;
  double rate;

  Currency({this.name, this.code, this.flag, this.rate});

  factory Currency.fromJson(dynamic jsonObject) {
    String f = jsonObject['code'].toString().substring(0, 2).toLowerCase();
    print('$f');
    if (f == 'il') f = 'ps';
    String n = jsonObject['name'];
    if (n == 'Israeli New Sheqel') n = 'Palestinian New Shekel';
    return Currency(
      name: jsonObject['name'],
      code: jsonObject['code'],
      flag: "https://flagcdn.com/64x48/$f.png",
      rate: jsonObject['rate'],
    );
  }
}
