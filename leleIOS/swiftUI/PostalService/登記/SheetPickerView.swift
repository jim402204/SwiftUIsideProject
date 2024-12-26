//
//  SheetPickerView.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/23.
//
import SwiftUI
import Observation

@Observable
class PickerSelection {
    
    var selectedHousehold: Int = 0
    var selectedDoorPlate: Int = 0
    var selectedFloor: Int = 0
    
    var selectedResult = "選擇戶別"
    var households: [HouseHoldDatum]

    init(households: [HouseHoldDatum] = []) {
        self.households = households
    }

    func updateSelectedResult() {
        selectedResult = getSelectedResult
    }
    
    // 获取结果字符串
    var getSelectedResult: String {
        // 检查索引范围并生成拼接结果
        if let household = currentHousehold,
           let doorPlate = currentDoorPlate,
           let floor = currentFloor {
            return "\(household.name) / \(doorPlate.name) / \(floor.name)"
        } else {
            return "選擇戶別"
        }
    }
    
    var selectedModel: HouseHold? {
        guard let household = currentHousehold?.name else { return nil }
        guard let doorPlate = currentDoorPlate?.name else { return nil }
        guard let floor = currentFloor?.name else { return nil }
        return HouseHold(building: household, doorPlate: doorPlate, floor: floor)
    }
    
    // 计算属性：当前选择的棟
    var currentHousehold: HouseHoldDatum? {
        households.indices.contains(selectedHousehold) ? households[selectedHousehold] : nil
    }
    
    // 计算属性：当前选择的號
    var currentDoorPlate: HouseHoldDatum.DoorPlate? {
        guard let household = currentHousehold,
              household.doorPlate.indices.contains(selectedDoorPlate) else {
            return nil
        }
        return household.doorPlate[selectedDoorPlate]
    }
    
    // 计算属性：当前选择的樓
    var currentFloor: HouseHoldDatum.Floor? {
        guard let doorPlate = currentDoorPlate,
              doorPlate.floor.indices.contains(selectedFloor) else {
            return nil
        }
        return doorPlate.floor[selectedFloor]
    }
    
    func reset() {
        selectedHousehold = 0
        selectedDoorPlate = 0
        selectedFloor = 0
    }
}

// Sheet Content View
struct PickerSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var pickerVM: PickerSelection
    @Binding var isPresented: Bool
    let selected = "選取項目"
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    isPresented = false
                }
                Spacer()
                Text(selected)
                    .font(.headline)
                Spacer()
                Button("完成") {
                    pickerVM.updateSelectedResult()
                    isPresented = false
                }
            }
            .padding()
            .frame(height: 34)
            
            Divider()
            
            HStack {
                Picker("Household", selection: $pickerVM.selectedHousehold) {
                    ForEach(Array(pickerVM.households.enumerated()), id: \.0) { index, model in
                        Text(model.name).tag(index)
                    }
                }
                Picker("Door Plate", selection: $pickerVM.selectedDoorPlate) {
                    // 确保 selectedHousehold 在有效范围内
                    if pickerVM.households.indices.contains(pickerVM.selectedHousehold) {
                        ForEach(Array(pickerVM.households[pickerVM.selectedHousehold].doorPlate.enumerated()), id: \.0) { index,model in
                            Text(model.name).tag(index)
                        }
                    }
                }
                Picker("Floor", selection: $pickerVM.selectedFloor) {
                    // 确保 selectedHousehold 和 selectedDoorPlate 在有效范围内
                    if pickerVM.households.indices.contains(pickerVM.selectedHousehold),
                       pickerVM.households[pickerVM.selectedHousehold].doorPlate.indices.contains(pickerVM.selectedDoorPlate) {
                        
                        ForEach(Array(pickerVM.households[pickerVM.selectedHousehold].doorPlate[pickerVM.selectedDoorPlate].floor.enumerated()), id: \.0) { index, floor in
                            Text(floor.name).tag(index)
                        }
                    }
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .onChange(of: pickerVM.selectedHousehold) {
            // Reset dependent selections when Household changes
            pickerVM.selectedDoorPlate = 0
            pickerVM.selectedFloor = 0
        }
        .onChange(of: pickerVM.selectedDoorPlate) {
            // Reset Floor selection when Door Plate changes
            pickerVM.selectedFloor = 0
        }
        .onAppear() {
            pickerVM.reset()
        }
        .presentationDetents([.height(200)])
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var pickerSelection = PickerSelection(
        households: HouseHoldDatum.previewData()
    )
    @Previewable @State var isSheetPresented = false
    
    PickerSheetView(pickerVM: $pickerSelection, isPresented: $isSheetPresented)
        .frame(width: .infinity, height: 300)
}

extension HouseHoldDatum {
    static func previewData() -> [HouseHoldDatum] {
           return [
               HouseHoldDatum(
                   index: 0,
                   doorPlate: [
                       DoorPlate(
                           floor: [
                               Floor(name: "1樓", index: 0),
                               Floor(name: "2樓", index: 1),
                               Floor(name: "3樓", index: 2)
                           ],
                           index: 0,
                           name: "1號"
                       ),
                       DoorPlate(
                           floor: [
                               Floor(name: "1樓", index: 0),
                               Floor(name: "2樓", index: 1)
                           ],
                           index: 1,
                           name: "2號"
                       )
                   ],
                   name: "A1棟"
               ),
               HouseHoldDatum(
                   index: 1,
                   doorPlate: [
                       DoorPlate(
                           floor: [
                               Floor(name: "1樓", index: 0),
                               Floor(name: "2樓", index: 1),
                               Floor(name: "3樓", index: 2)
                           ],
                           index: 0,
                           name: "1號"
                       )
                   ],
                   name: "A2棟"
               ),
               HouseHoldDatum(
                   index: 2,
                   doorPlate: [
                       DoorPlate(
                           floor: [
                               Floor(name: "1樓", index: 0),
                               Floor(name: "2樓", index: 1)
                           ],
                           index: 0,
                           name: "1號"
                       ),
                       DoorPlate(
                           floor: [
                               Floor(name: "1樓", index: 0)
                           ],
                           index: 1,
                           name: "2號"
                       )
                   ],
                   name: "A3棟"
               )
           ]
       }
}
