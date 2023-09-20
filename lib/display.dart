import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Data'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('student').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(); // Display loading indicator while data is being fetched.
            }
            var documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data();
                return ListTile(
                  title: Text('Name: ${data['Name']}'),
                  subtitle: Text('Email: ${data['Email']}'),
                  trailing: Text(data['Age'].toString()),
                  // Add more widgets to display other data fields (Age, Password, etc.) as needed.
                );
              },
            );
          },
        ),
      ),
    );
  }
}
