//
//  TextPicker.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/23.
//


import SwiftUI

let households = [
    HouseholdFake(name: "Household 1", doorPlates: [
        DoorPlateFake(name: "Door A", floors: ["1F", "2F", "3F"]),
        DoorPlateFake(name: "Door B", floors: ["1F", "2F"])
    ]),
    HouseholdFake(name: "Household 2", doorPlates: [
        DoorPlateFake(name: "Door C", floors: ["1F", "3F"])
    ])
]

struct TextPicker: View {
    @State private var selectedHousehold = 0
    @State private var selectedDoorPlate = 0
    @State private var selectedFloor = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Household, Door Plate, and Floor")
                .font(.headline)

            HStack {
                Picker("Household", selection: $selectedHousehold) {
                    ForEach(0..<households.count, id: \.self) { index in
                        Text(households[safe: index]?.name ?? "").tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)

                Picker("Door Plate", selection: $selectedDoorPlate) {
                    ForEach(0..<households[selectedHousehold].doorPlates.count, id: \.self) { index in
                        Text(households[safe: selectedHousehold]?.doorPlates[safe: index]?.name ?? "").tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)

                Picker("Floor", selection: $selectedFloor) {
                    ForEach(0..<households[selectedHousehold].doorPlates[selectedDoorPlate].floors.count, id: \.self) { index in
                        Text(households[safe: selectedHousehold]?.doorPlates[safe: selectedDoorPlate]?.floors[safe: index] ?? "").tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
            }
            .frame(height: 150)

            VStack(alignment: .leading, spacing: 10) {
                Text("Selected Household: \(households[safe:  selectedHousehold]?.name)")
                Text("Selected Door Plate: \(households[safe: selectedHousehold]?.doorPlates[safe: selectedDoorPlate]?.name)")
                Text("Selected Floor: \(households[safe: selectedHousehold]?.doorPlates[safe: selectedDoorPlate]?.floors[safe: selectedFloor])")
            }
            .padding(.top, 20)
        }
        .padding()
        .onChange(of: selectedHousehold) {
            // Reset dependent pickers
            selectedDoorPlate = 0
            selectedFloor = 0
        }
        .onChange(of: selectedDoorPlate) {
            selectedFloor = 0
        }
    }
}

// Supporting Models
struct HouseholdFake: Codable {
    let name: String
    let doorPlates: [DoorPlateFake]
}

struct DoorPlateFake: Codable {
    let name: String
    let floors: [String]
}


#Preview {
    TextPicker()
}
