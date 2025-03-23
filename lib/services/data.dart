import 'package:flutter_application_1/model/categoryModel.dart';

List<Categorymodel> getcategories(){

  List<Categorymodel> category= [];
  Categorymodel categorymodel = Categorymodel();

  categorymodel.categoryName="Business";
  categorymodel.image="images/business.jpg";
  category.add(categorymodel);
  categorymodel= Categorymodel();

  categorymodel.categoryName="Entertainment";
  categorymodel.image="images/entertainment.jpg";
  category.add(categorymodel);
  categorymodel= Categorymodel();

  categorymodel.categoryName="Health";
  categorymodel.image="images/health.jpg";
  category.add(categorymodel);
  categorymodel= Categorymodel();

  categorymodel.categoryName="Science";
  categorymodel.image="images/science.jpg";
  category.add(categorymodel);
  categorymodel= Categorymodel();

  categorymodel.categoryName="Sports";
  categorymodel.image="images/sports.jpg";
  category.add(categorymodel);
  categorymodel= Categorymodel();

  categorymodel.categoryName="Tech";
  categorymodel.image="images/tech.jpg";
  category.add(categorymodel);
  categorymodel= Categorymodel();

  return category;
}