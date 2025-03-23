import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/categoryModel.dart';
import 'package:flutter_application_1/services/data.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

List<Categorymodel> categories=[];
@override
  void initState() {
  categories= getcategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Wise"), 
          Text(
            "Indo", 
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )

          ],

        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
          Container(
            margin: EdgeInsets.only(left: 10.0),
            height: 70,
            child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryTile(
                image: categories[index].image, 
                categoryName: categories[index].categoryName,
              );
            }),
          )
        ],
      ),
    ),
  );
}
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  const CategoryTile({super.key, this.categoryName, this.image});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              image, 
              width: 120, 
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          Container(
              width: 120, 
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
            child: Center(
              child: Text(
                categoryName, 
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              )),
          )
        ],
      ),
    );
  }
}