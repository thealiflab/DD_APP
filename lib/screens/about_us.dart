import "package:flutter/material.dart";

class AboutUs extends StatelessWidget {
  static const String id = "aboutUs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("About Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 25,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Who we are?\n",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "We started our journey in 2019 with one goal in mind- to make lives easier. As a technology-first company, we develop tech-driven solutions for the everyday challenges of Bangladeshi people. The DD Super App serves as a single portal connecting local people to local businesses providing a wide range of products and services like food, tickets, rides, truck rentals, and healthcare. Our on-demand service platform provides all the customer care must-haves- a digital marketplace, speedy logistical support, and a customer support call center. DD is more than just a service platform.\n\nDD is a lifestyle. We empower our people by solving and simplifying their daily needs problem and let them enjoy life, the DD way.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
