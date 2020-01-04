import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculatoer App",
    home: SIForm(),
    theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
        brightness: Brightness.dark),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  final _minimumPadding = 5.0;
  var _currencies = ["Dollars", "Pounds", "Euros", "Others"];
  String _currentItemSelected = "";
  var displayResult = "";
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("An SI Calculator"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(top: _minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    controller: principalController,
                    validator: _validateFields,
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.yellow, fontSize: 15.0),
                        labelText: "Principal",
                        hintText: "Enter pincipal e:g 2100",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    validator: _validateFields,
                    controller: roiController,
                    decoration: InputDecoration(
                        labelText: "Rate Of Interest",
                        hintText: "In Percentage",
                        labelStyle: textStyle,
                        errorStyle:
                            TextStyle(color: Colors.yellow, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        validator: _validateFields,
                        controller: termController,
                        decoration: InputDecoration(
                            labelText: "Term",
                            errorStyle:
                                TextStyle(color: Colors.yellow, fontSize: 15.0),
                            hintText: "Number Of Years",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                      Container(
                        width: _minimumPadding * 5,
                      ),
                      Expanded(
                          child: DropdownButton<String>(
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          _onDropDownItemSelected(newValueSelected);
                        },
                        value: _currentItemSelected,
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              this.displayResult = _calculateTotalReturns();
                            }
                          });
                        },
                        child: Text(
                          "Calculate",
                          textScaleFactor: 1.5,
                        ),
                      )),
                      Expanded(
                          child: RaisedButton(
                        textColor: Theme.of(context).primaryColorLight,
                        color: Theme.of(context).primaryColorDark,
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                        child: Text(
                          "Reset",
                        ),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _minimumPadding),
                  child: Text(
                    displayResult,
                    style: textStyle,
                  ),
                )
              ],
            ),
          )
//        margin: EdgeInsets.all(_minimumPadding * 2),

          ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = new AssetImage("images/interest.png");
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);
    double totalAmountPayable = (principal * roi * term);
    String result =
        "After $term years, total amount payable will be $totalAmountPayable $_currentItemSelected";
    debugPrint(result);
    return result;
  }

  void _reset() {
    principalController.text = "";
    roiController.text = "";
    termController.text = "";
    _currentItemSelected = _currencies[0];
  }

  String _validateFields(String value) {
    if (value.isEmpty) return "Please Enter a Value Here";
  }
}
