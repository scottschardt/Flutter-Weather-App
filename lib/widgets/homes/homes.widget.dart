import "package:flutter/material.dart";
import "./homes.view.dart";

class Homes extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return new HomesState();
  }
}

class HomesState extends State<Homes> {
  
  @override
  Widget build(BuildContext context) {
    return homesViewBuild(this);
  }
}
