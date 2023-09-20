import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googlemap/Googlemap.dart';
import 'package:googlemap/api/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googlemap/display.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    setState(() {
      _imageFile = File(pickedImage.path);
    });

    // Print the URL of the selected image.
    print("Image URL: ${_imageFile?.path}");
  }

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                _imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(
                            _imageFile!,
                          ),
                        ))
                    : Container(),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black, // Change the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the border radius as needed
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Pick Image',
                      style: TextStyle(
                          fontSize: 16.0), // Change the text style as needed
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                        labelText: 'Enter Your Name',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                        labelText: 'Enter Your Email',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _age,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Enter Your git',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _password,
                    decoration: InputDecoration(
                        labelText: 'Enter Your Password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black))),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Change the text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the border radius as needed
                      ),
                    ),
                    onPressed: () {
                      CollectionReference collref =
                          FirebaseFirestore.instance.collection('student');
                      collref.add({
                        'Name': _name.text,
                        'Email': _email.text,
                        'Age': _age.text,
                        'Password': _password.text,
                        'ImageUrl': _imageFile?.path
                      });
                    },
                    child: Text("Insert")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Change the text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the border radius as needed
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayData()));
                    },
                    child: Text("Display Data")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Change the text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the border radius as needed
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    title: '',
                                  )));
                    },
                    child: Text("Google Map View")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'todo_model.dart';
// import 'todo_provider.dart';
// import 'package:bottom_sheet/bottom_sheet.dart';
// import 'package:file_picker/file_picker.dart';

// class TodoApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => TodoProvider(),
//       child: MaterialApp(
//         home: Scaffold(
//           appBar: AppBar(
//             title: Text('To-Do List'),
//           ),
//           body: TodoList(),
//         ),
//       ),
//     );
//   }
// }

// class TodoList extends StatefulWidget {
//   @override
//   State<TodoList> createState() => _TodoListState();
// }

// class _TodoListState extends State<TodoList> {
//   Future<void> pickFile(BuildContext context) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom, // Customize file types as needed
//       allowMultiple: false, // Allow selecting only one file
//     );

//     if (result != null && result.files.isNotEmpty) {
//       // Handle the picked file here, e.g., send it or process it
//       final file = result.files.first;
//       print('File path: ${file.path}');
//       print('File name: ${file.name}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<TodoProvider>(context);

//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: ListView.builder(
//             itemCount: provider.tasks.length,
//             itemBuilder: (context, index) {
//               final task = provider.tasks[index];
//               return ListTile(
//                 title: Text(task.title),
//                 // leading: Checkbox(
//                 //   value: task.isCompleted,
//                 //   onChanged: (_) {
//                 //     provider.toggleTask(index);
//                 //   },
//                 // ),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     provider.deleteTask(index);
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Type a message',
//               prefixIcon:
//                   Icon(Icons.emoji_emotions), // Add emoji icon on the left
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.attach_file),
//                 onPressed: () {
//                   showModalBottomSheet(
//                     shape: const RoundedRectangleBorder(
//                       // <-- SEE HERE
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(25.0),
//                       ),
//                     ),
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Container(
//                         padding: EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             ListTile(
//                               leading: Icon(
//                                 color: Colors.black,
//                                 Icons.photo_camera,
//                               ),
//                               title: Text(
//                                 'Camera',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(
//                                     context); // Close the bottom sheet
//                                 // Handle camera option
//                               },
//                             ),
//                             SizedBox(width: 40),
//                             ListTile(
//                               leading: Icon(
//                                 color: Colors.black,
//                                 Icons.image,
//                               ),
//                               title: Text(
//                                 'Gallery',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(
//                                     context); // Close the bottom sheet
//                                 // Handle camera option
//                               },
//                             ),
//                             SizedBox(
//                               width: 40,
//                             ),
//                             ListTile(
//                               leading: Icon(
//                                 color: Colors.black,
//                                 Icons.insert_drive_file,
//                               ),
//                               title: Text(
//                                 'Document',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(
//                                     context); // Close the bottom sheet
//                                 // Handle camera option
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),

//               filled: true,
//               fillColor: Colors.white, // Background color
//               contentPadding:
//                   EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30.0), // Rounded border
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius:
//                     BorderRadius.circular(30.0), // Rounded border when focused
//                 borderSide: BorderSide(
//                   color: Colors.transparent, // Remove border color
//                 ),
//               ),
//             ),
//             onFieldSubmitted: (value) {
//               provider.addTask(value);
//             },
//             // maxLines: null,
//           ),
//         ),
//       ],
//     );
//   }
// }

// void main() {
//   runApp(TodoApp());
// }

// Widget attachmentOption({
//   required IconData icon,
//   required String label,
//   required Function onTap,
// }) {
//   return GestureDetector(
//     onTap: () {
//       onTap();
//     },
//     child: Column(
//       children: <Widget>[
//         Icon(
//           icon,
//           size: 48.0,
//           color: Colors.blue, // Customize icon color
//         ),
//         SizedBox(height: 8.0),
//         Text(
//           label,
//           style: TextStyle(fontSize: 14.0),
//         ),
//       ],
//     ),
//   );
// }
