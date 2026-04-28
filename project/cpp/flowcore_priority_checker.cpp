// FlowCore D09: C++ Priority Placement Decision Checker.
// Decision rule: high-quantity pallets should use active priority locations.

#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>

using namespace std;

const int HIGH_QUANTITY = 12;
const int MIN_PRIORITY = 2;

struct Location {
    string active;
    int priority;
};

string cell(const string& line, int index) {
    string value;
    stringstream stream(line);
    for (int i = 0; getline(stream, value, ','); ++i) {
        if (i == index) return value;
    }
    return "";
}

int fail(ofstream& report, const string& message, int code = 1) {
    report << "Result: FAIL\n[FAIL] " << message << "\n";
    cerr << "[FLOWCORE_CPP] " << message << "\n";
    return code;
}

int main() {
    ifstream locations_file("runtime/snapshots/location_usage.csv");
    ifstream pallets_file("runtime/snapshots/pallet_state.csv");
    ofstream report("runtime/reports/cpp_priority_report.txt");
    ofstream decisions("runtime/reports/cpp_priority_decisions.csv");

    if (!locations_file || !pallets_file) {
        return fail(report, "Missing runtime CSV input.", 2);
    }

    map<string, Location> locations;
    string line;
    getline(locations_file, line); // skip header

    while (getline(locations_file, line)) {
        string location_id = cell(line, 0);
        if (!location_id.empty()) {
            locations[location_id] = {cell(line, 4), stoi(cell(line, 5))};
        }
    }

    decisions << "pallet_id,quantity,assigned_location,location_priority,decision,message\n";

    int priority_pallets = 0;
    getline(pallets_file, line); // skip header

    while (getline(pallets_file, line)) {
        if (cell(line, 5) != "STORED") continue;

        string pallet_id = cell(line, 0);
        int quantity = stoi(cell(line, 3));
        string location_id = cell(line, 4);
        if (quantity < HIGH_QUANTITY) continue;

        priority_pallets++;
        if (!locations.count(location_id)) {
            return fail(report, "Priority pallet " + pallet_id + " uses an unknown location.");
        }

        Location location = locations[location_id];
        string decision = "APPROVED";
        string message = "High quantity pallet assigned to priority active location";

        if (location.active != "Y" || location.priority < MIN_PRIORITY) {
            decision = "REVIEW";
            message = "High quantity pallet should be moved to a priority active location";
        }

        decisions << pallet_id << "," << quantity << "," << location_id << ","
                  << location.priority << "," << decision << "," << message << "\n";

        if (decision != "APPROVED") {
            return fail(report, "Priority placement review required for " + pallet_id + ".");
        }
    }

    report << "FlowCore C++ Priority Placement Decision Checker\n";
    report << "High quantity threshold: " << HIGH_QUANTITY << "\n";
    report << "Minimum location priority: " << MIN_PRIORITY << "\n";
    report << "Priority pallets checked: " << priority_pallets << "\n";
    report << "Result: PASS\n";

    cout << "[FLOWCORE_CPP] Priority pallets checked: " << priority_pallets << "\n";
    cout << "[FLOWCORE_CPP] Priority placement decision passed.\n";
    return 0;
}
