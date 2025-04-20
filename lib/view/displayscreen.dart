import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchRandomUser();
  }

  Future<void> fetchRandomUser() async { // Load data from given API
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try { // handling failed API call
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      // test error 
      // final response = await http.get(Uri.parse('https://randouser.me/api/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['results'][0];
          isLoading = false;
        });

      } else {
        throw Exception('Server error: ${response.statusCode}');
      }

    } catch (e) {
      setState(() {
        isLoading = false;
        userData = null;
        hasError = true;
      });

      ScaffoldMessenger.of(context).showSnackBar( // error message
        SnackBar(
          content: Text("OOps. Something went wrong! \n$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget sectionTitle(String title) => Padding( // Section title for info categories
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 38, 255),
          ),
        ),
      );

  Widget sectionHeaderWithButton(String title, VoidCallback onPressed) => // Let button stay at top right 
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 38, 255),
              ),
            ),

            ElevatedButton.icon( // Button to refresh user profile
              onPressed: onPressed,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text("Load Another User"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                textStyle: const TextStyle(fontSize: 14),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                foregroundColor: Color.fromARGB(255, 64, 0, 255),
              ),
            )

          ],
        ),
      );


  Widget infoText(String title, String value) => Padding( // User data format design
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) { // Display screen title for user
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Oops! Something went wrong.",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchRandomUser,
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                )
              : userData == null
                  ? const Center(child: Text("No user data available"))
                  : RefreshIndicator(
                      onRefresh: fetchRandomUser,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar( // user profile picture
                              radius: 70,
                              backgroundImage:
                                  NetworkImage(userData!['picture']['large']),
                            ),
                            const SizedBox(height: 20),

                            Container( 
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 233, 255),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: 
                                    const Color.fromARGB(255, 249, 253, 255),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),

                              child: Column( // Display user data in 3 category
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sectionHeaderWithButton( 
                                      "Personal Info", fetchRandomUser), 
                                  infoText("Username",
                                      "${userData!['login']['username']}"),
                                  infoText(
                                      "Name",
                                      "${userData!['name']['title']} ${userData!['name']['first']} ${userData!['name']['last']}"),
                                  infoText("Gender", "${userData!['gender']}"),
                                  infoText(
                                      "Birthday", "${userData!['dob']['date']}"),
                                  infoText("Age", "${userData!['dob']['age']}"),

                                  const Divider(height: 15),

                                  sectionTitle("Contact"),
                                  infoText("Email", "${userData!['email']}"),
                                  infoText("Phone", "${userData!['phone']}"),

                                  const Divider(height: 15),
                                  
                                  sectionTitle("Address"),
                                  infoText(
                                    "Country",
                                      "${userData!['location']['country']}"),
                                  infoText(
                                      "City", "${userData!['location']['city']}"),
                                  infoText(
                                      "Street",
                                      "${userData!['location']['street']['name']} ${userData!['location']['street']['number']}"),
                                  infoText("Postcode",
                                      "${userData!['location']['postcode']}"),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
    );
  }
}
