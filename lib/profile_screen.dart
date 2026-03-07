import 'package:flutter/material.dart';
import 'database_helper.dart';

class ProfileScreen extends StatefulWidget { 
  const ProfileScreen({super.key}); 

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(); 
}

class _ProfileScreenState extends State<ProfileScreen> { 

  //bottom navigation
  int selectedIndex = 3;

  //editable textfields
  bool isEditing = false;

// text controllers for profile data
  final TextEditingController nameController =
      TextEditingController(text: "Alex"); 
  final TextEditingController ageController =
      TextEditingController(text: "35");
  final TextEditingController conditionController =
      TextEditingController(text: "ME/CFS");
  final TextEditingController restingController =
      TextEditingController(text: "68");
  final TextEditingController maxController =
      TextEditingController(text: "180");

  @override
  void initState() { 
    super.initState();

    //load profile data from local database when screen initializes
    loadProfile();
  }

//retrieves saved profile data from db
//if data exist populate text controllers
  Future<void> loadProfile() async {
    final data = await DatabaseHelper.instance.getProfile();
    if (data != null) {
      setState(() { //"helps UI update"
        nameController.text = data['name'];
        ageController.text = data['age'].toString();
        conditionController.text = data['condition'];
        restingController.text = data['RHR'].toString();
        maxController.text = data['MHR'].toString();
      });
    }
  }

 //validates and saves profile data into the database
 //ensures numeric fields contain valid integers
  Future<void> saveProfile() async { 

    //ensures numeric fields are not empty
    if (ageController.text.trim().isEmpty ||
        restingController.text.trim().isEmpty ||
        maxController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all numeric fields")),
      );
      return;
    }

   //parse numeric values
    final int? age = int.tryParse(ageController.text.trim());
    final int? rhr = int.tryParse(restingController.text.trim());
    final int? mhr = int.tryParse(maxController.text.trim());

   //valid numeric conversion
    if (age == null || rhr == null || mhr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only numeric values allowed")),
      );
      return;
    }

//create datamap for database insertion
    final profileData = {
      "name": nameController.text.trim(),
      "age": age,
      "condition": conditionController.text.trim(),
      "RHR": rhr,
      "MHR": mhr,
    };

    //save profile locally using database helper
    await DatabaseHelper.instance.saveProfile(profileData);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
  }

//toggles between edit and save mode
//if currently editing, save data before switching state
  void toggleEditSave() async {
    if (isEditing) {
      await saveProfile();
    }
    setState(() {
      isEditing = !isEditing; 
    });
  }

//dispose controllers to prevent memory leaks

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    conditionController.dispose();
    restingController.dispose();
    maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.grey[100],

      //bottom navigation bar
      //enables switching between main app sections
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Insights"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Zones"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      //main scrollable content
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Column(
            children: [
              // HEADER
              //displays screen title and description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(color: Colors.red),
                child: const Column(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Manage your personal information",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // PROFILE CARD
              //displays quick overview of user identity and condition
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.person,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameController.text,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("${ageController.text} years old"), 
                          const SizedBox(height: 5),
                          Text(
                            "Condition: ${conditionController.text}", 
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // HEALTH BASELINE
              //used for personal hr zone calculations
              sectionTitleWithButton("Health Baseline"),
              buildCard([
                buildField("Name", nameController, false),
                buildField("Age", ageController, true),
                buildField("Condition", conditionController, false),
                buildField("Resting Heart Rate (bpm)", restingController, true),
                const Text(
                  "Your heart rate when completely at rest",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                buildField("Maximum Heart Rate (bpm)", maxController, true),
                const Text(
                  "Adjusted maximum for your condition",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ]),

              const SizedBox(height: 20),

              // GOALS
              buildSectionTitle("Your Goals"),
              buildCard([ 
                goalItem("Improve pacing"),
                goalItem("Reduce PEM episodes"),
                goalItem("Track recovery"),
              ]),

              const SizedBox(height: 20),

              // ZONES calculation explanation
              buildSectionTitle("How Your Zones Are Calculated"),
              buildCard([
                const Text(
                  "Your personalized activity zones are calculated using "
                  "your resting heart rate and maximum heart rate.\n\n"
                  "The formula uses Heart Rate Reserve (HRR), which is:\n"
                  "HRR = Maximum HR - Resting HR\n\n"
                  "Zone 1 (Recovery): 0-30% of HRR\n"
                  "Zone 2 (Sustainable): 30-50% of HRR\n"
                  "Zone 3 (Caution): 50-65% of HRR\n"
                  "Zone 4 (Risk): 65-80% of HRR\n"
                  "Zone 5 (Overexertion): 80-100% of HRR\n\n"
                  "These percentages are adapted to be conservative and "
                  "safe for energy-limiting conditions.",
                  style: TextStyle(color: Colors.grey),
                )
              ]),

              const SizedBox(height: 20),

              // DATA & PRIVACY
              buildSectionTitle("Data & Privacy"),
              buildCard([
                const Text(
                  "All your health data is stored locally on your device. "
                  "No data is sent to external servers.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar( 
                            const SnackBar(content: Text("Exporting data...")), 
                          );
                        },
                        child: const Text("Export Data"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded( 
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          await DatabaseHelper.instance.clearProfile(); 
                          loadProfile();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("All data cleared!")),
                          );
                        },
                        child: const Text("Clear All Data"),
                      ),
                    ),
                  ],
                )
              ]),

              const SizedBox(height: 20),

              // ABOUT
              buildSectionTitle("About Elaros"),
              buildCard([
                const Text(
                  "Elaros is designed to help individuals with energy-limiting "
                  "conditions such as ME/CFS, Long COVID, and Fibromyalgia "
                  "better understand and manage their activity levels.\n\n"
                  "By providing insights from wearable device data, "
                  "Elaros supports better pacing strategies and helps "
                  "prevent post-exertional malaise (PEM).\n\n"
                  "Version 1.0.0\n"
                  "Built with care for the chronic illness community.",
                  style: TextStyle(color: Colors.grey),
                )
              ]),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

//section title with edit/save toggle button
  Widget sectionTitleWithButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: toggleEditSave,
            child: Text(isEditing ? "Save" : "Edit"), 
          )
        ],
      ),
    );
  }

//reusable section title widget
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

//reusable card container for grouped ui elements
  Widget buildCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

//reusable input field widget
//isNumber determines keyboard type and validation expectation
  Widget buildField(String label, TextEditingController controller, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: isEditing,
            keyboardType:
                isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  isEditing ? Colors.white : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

//reusable goal item row with check icon
  Widget goalItem(String text) {      
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}