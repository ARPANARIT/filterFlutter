import 'package:flutter/material.dart';
import 'package:ostello/constants.dart';

import 'package:ostello/model/dummy_model.dart';

import 'api/dummyApi.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedValue = 'Price';
  List<String> itemList = ['Relevance', 'Price', 'Ratings', 'Distance'];
  Widget dropdown() {
    return DropdownButton<String>(
      underline: Container(),
      icon: Icon(Icons.arrow_drop_down_circle_outlined),
      isDense: true,
      elevation: 8,
      iconEnabledColor: purple,
      items: itemList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: <Widget>[
              Radio<String>(
                activeColor: purple,
                value: value,
                groupValue: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!; // Update the selectedValue
                  });
                  selectedValue = '';
                },
              ),
              Text(value),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value!;
        });
      },
    );
  }

  Container coupon(String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: purple,
      ),
      padding: EdgeInsets.all(8.0),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Container subject(String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: purple, width: 1.5),
      ),
      padding: EdgeInsets.all(8.0),
      child: Text(
        label,
        style: TextStyle(color: purple),
      ),
    );
  }

// Assuming you have the original list of Dummy objects
  List<Dummy> originalData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundColor: purple,
            radius: 18,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          'For JEE Mains',
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Search for UPSC Coaching',
                hintStyle: TextStyle(color: Colors.purple, fontSize: 12),
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.grey[800],
                    ),
                    Text(
                      '|',
                      style: TextStyle(fontSize: 30),
                    ),
                    Icon(
                      Icons.mic,
                      color: purple,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(color: purple, width: 2),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                filterTab('Filter'),
                SizedBox(
                  width: 6,
                ),
                sort(),
                SizedBox(
                  width: 6,
                ),
                filterTab('JEE'),
                SizedBox(
                  width: 6,
                ),
                filterTab('< 2 Km'),
              ],
            ),
          ),
          Container(
            child: FutureBuilder<List<Dummy>>(
              future: Api.getData(context),
              builder: (context, snapshot) {
                final dummies = snapshot.data;
                if (snapshot.hasData && originalData.isEmpty) {
                  originalData = snapshot.data!;
                }
                // Sort the data based on the selectedSortOption
                else if (originalData.isNotEmpty) {
                  snapshot.data!.sort((a, b) {
                    switch (selectedValue) {
                      case 'Price':
                        return a.price.compareTo(b.price);
                      case 'Ratings':
                        return a.ratings.compareTo(b.ratings);
                      default:
                        return 0;
                    }
                  });
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Couldn\'t Load Data',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    } else {
                      if (snapshot.hasData) {
                        return Column(children: [
                          for (var dummy in dummies!) buildCardTwo(dummy),
                        ]);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  TextButton filterTab(String label) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: StadiumBorder(
          side: BorderSide(color: purple, width: 0.5),
        ),
      ),
      onPressed: () {},
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 24, color: purple, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget sort() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: StadiumBorder(
          side: BorderSide(color: purple, width: 0.5),
        ),
      ),
      onPressed: () {},
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            'Sort',
            style: TextStyle(
                fontSize: 24, color: purple, fontWeight: FontWeight.w300),
          ),
          dropdown(),
        ],
      ),
    );
  }

  Widget buildCard(List<Dummy> dummies) => ListView.builder(
        itemCount: dummies.length,
        itemBuilder: (context, index) {
          final dummy = dummies[index];

          return ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.all(10),
              color: lightPurple,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: Container(
                            color: purple,
                            height: 150,
                            child: Container(),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                dummy.name,
                                maxLines: 2,
                                // Set the maximum number of lines to 2
                                overflow: TextOverflow.ellipsis,
                                // Use ellipsis (...) if the text exceeds 2 lines
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.stars_rounded,
                                  color: Colors.green,
                                ),
                                Text(dummy.ratings),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('.'),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Price: ${dummy.price}')
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: [
                                subject('PHYSICS'),
                                SizedBox(
                                  width: 8,
                                ),
                                subject('CHEMISTRY'),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: [
                                subject('MATHS'),
                                SizedBox(
                                  width: 8,
                                ),
                                subject('JEE'),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: [
                                coupon('20% OFF'),
                                Text(
                                  'Distance:',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
  Widget buildCardTwo(Dummy dummy) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(10),
        color: lightPurple,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                height: 150,
                width: 150,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Image.asset(dummy.image)),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        dummy.name,
                        maxLines: 2,
                        // Set the maximum number of lines to 2
                        overflow: TextOverflow.ellipsis,
                        // Use ellipsis (...) if the text exceeds 2 lines
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            color: Colors.green,
                          ),
                          Text(dummy.ratings),
                          SizedBox(
                            width: 10,
                          ),
                          Text('.'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Price: ${dummy.price}')
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          subject('PHYSICS'),
                          SizedBox(
                            width: 8,
                          ),
                          subject('CHEMISTRY'),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          subject('MATHS'),
                          SizedBox(
                            width: 8,
                          ),
                          subject('JEE'),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      coupon('20% OFF'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
