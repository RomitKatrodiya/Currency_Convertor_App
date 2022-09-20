import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import '../helpers/currency_convert_api.dart';
import '../main.dart';
import '../modals/currency_convert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<CurrencyConvert?> future;
  TextEditingController amtController = TextEditingController();

  TextStyle fromToStyle = TextStyle(
    color: Global.appColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    future = CurrencyConvertAPI.weatherAPI
        .currencyConvertorAPI(from: "USD", to: "INR", amt: 1);

    amtController.text = "1";
  }

  String fromCurrency = "USD";
  String toCurrency = "INR";

  @override
  Widget build(BuildContext context) {
    return (Global.isAndroid == false)
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Currency Convertor"),
              actions: [
                Switch(
                    onChanged: (val) {
                      Global.isAndroid = val;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                          (route) => false);
                    },
                    value: Global.isAndroid),
              ],
            ),
            body: FutureBuilder(
              future: future,
              builder: (context, snapShot) {
                if (snapShot.hasError) {
                  return Center(
                    child: Text("${snapShot.error}"),
                  );
                } else if (snapShot.hasData) {
                  CurrencyConvert? data = snapShot.data;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 240,
                          child: Image.asset(
                            "assets/images/currency_convert_img.jpg",
                          ),
                        ),
                        Row(
                          children: [
                            Text("Amount  :", style: fromToStyle),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  controller: amtController,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          color: Global.appColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("From", style: fromToStyle),
                                    DropdownButtonFormField(
                                      value: fromCurrency,
                                      onChanged: (val) {
                                        setState(() {
                                          fromCurrency = val!;
                                        });
                                      },
                                      items: Global.currency.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("To", style: fromToStyle),
                                    DropdownButtonFormField(
                                      value: toCurrency,
                                      onChanged: (val) {
                                        setState(() {
                                          toCurrency = val!;
                                        });
                                      },
                                      items: Global.currency.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Global.appColor.withOpacity(0.2),
                          ),
                          child: Text(
                            "Result  :  ${data!.difference}",
                            style: TextStyle(
                              color: Global.appColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () {
                              if (amtController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Global.appColor,
                                    behavior: SnackBarBehavior.floating,
                                    content: const Text("Please Enter Amount"),
                                  ),
                                );
                              } else {
                                int amt = int.parse(amtController.text);
                                setState(() {
                                  future = CurrencyConvertAPI.weatherAPI
                                      .currencyConvertorAPI(
                                    from: fromCurrency,
                                    to: toCurrency,
                                    amt: amt,
                                  );
                                });
                              }
                            },
                            child: const Text(
                              "CONVERT",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              trailing: CupertinoSwitch(
                  activeColor: CupertinoColors.activeBlue.withOpacity(0.5),
                  onChanged: (val) {
                    Global.isAndroid = val;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                        (route) => false);
                  },
                  value: Global.isAndroid),
              backgroundColor: Global.appColor,
              middle: const Text(
                "Currency Convertor",
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
            backgroundColor: CupertinoColors.white,
            child: FutureBuilder(
              future: future,
              builder: (context, snapShot) {
                if (snapShot.hasError) {
                  return Center(
                    child: Text("${snapShot.error}"),
                  );
                } else if (snapShot.hasData) {
                  CurrencyConvert? data = snapShot.data;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 240,
                            child: Image.asset(
                              "assets/images/currency_convert_img.jpg",
                            ),
                          ),
                          Row(
                            children: [
                              Text("Amount  :", style: fromToStyle),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: CupertinoTextField(
                                    keyboardType: TextInputType.number,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(color: Global.appColor),
                                    ),
                                    controller: amtController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            color: Global.appColor,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("From", style: fromToStyle),
                                      GestureDetector(
                                        onTap: () {
                                          showCupertinoModalPopup(
                                              context: context,
                                              builder: (_) => SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    height: 250,
                                                    child: CupertinoPicker(
                                                      backgroundColor:
                                                          Colors.white,
                                                      itemExtent: 30,
                                                      children: Global.currency
                                                          .map((e) {
                                                        return Text(e);
                                                      }).toList(),
                                                      onSelectedItemChanged:
                                                          (value) {
                                                        setState(() {
                                                          fromCurrency = Global
                                                              .currency[value];
                                                        });
                                                      },
                                                    ),
                                                  ));
                                        },
                                        child: Container(
                                          color:
                                              Global.appColor.withOpacity(0.1),
                                          height: 45,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              Text(
                                                fromCurrency,
                                              ),
                                              const Spacer(),
                                              const Icon(CupertinoIcons
                                                  .arrow_2_squarepath),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("To", style: fromToStyle),
                                      GestureDetector(
                                        onTap: () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (_) => SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.60,
                                              height: 250,
                                              child: CupertinoPicker(
                                                backgroundColor: Colors.white,
                                                itemExtent: 30,
                                                children:
                                                    Global.currency.map((e) {
                                                  return Text(e);
                                                }).toList(),
                                                onSelectedItemChanged: (value) {
                                                  setState(() {
                                                    toCurrency =
                                                        Global.currency[value];
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color:
                                              Global.appColor.withOpacity(0.1),
                                          height: 45,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              Text(
                                                toCurrency,
                                              ),
                                              const Spacer(),
                                              const Icon(CupertinoIcons
                                                  .arrow_2_squarepath),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Global.appColor.withOpacity(0.2),
                            ),
                            child: Text(
                              "Result  :  ${data!.difference}",
                              style: TextStyle(
                                color: Global.appColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: CupertinoButton.filled(
                              borderRadius: BorderRadius.circular(50),
                              onPressed: () {
                                if (amtController.text.isEmpty) {
                                } else {
                                  int amt = int.parse(amtController.text);
                                  setState(() {
                                    future = CurrencyConvertAPI.weatherAPI
                                        .currencyConvertorAPI(
                                      from: fromCurrency,
                                      to: toCurrency,
                                      amt: amt,
                                    );
                                  });
                                }
                              },
                              child: const Text(
                                "CONVERT",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
  }
}
