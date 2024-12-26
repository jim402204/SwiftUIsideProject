//
//  PostalServiceEntryViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/20.
//


import Observation
import Foundation

@Observable
class CommunityInfoViewModel {
    
    // 包裹類型
    var packageType: [DefaultCommunityType] = []
    // 寄送廠商
    var shippingFrom: [DefaultCommunityType] = []
    // 物流廠商
    var shippingProvider: [DefaultCommunityType] = []
    // 所有戶別棟別
    var houseHoldData: [HouseHoldDatum] = []
    
    init (_ model: CommunityInfoModel) {

        self.packageType = model.defaultPackageType
        self.shippingFrom = model.defaultPackageType
        self.shippingProvider = model.defaultPackageType
        self.houseHoldData = model.houseHoldData
    }
    
    init() {}
    
}

@Observable
class PostalServiceEntryViewModel {
    
    var pickerViewModel = PickerSelection()
    
    // input
    var packageType: String = ""
    var optionType = "普通"
    var location = ""
    
    var recipient = ""
    var otherRecipient = ""
    var notes = ""
    
    // output
    var cInfoViewModel = CommunityInfoViewModel()
    var packagePlaceModels = [PackagePlaceListModel]()
    var householdUserModels = [MHouseholdModel.User]()
    var packageID: Int? = nil
    
    
    func callAPI() {
        
//        callTestAPI()
        callAsyncAPI()
    }
    
    func callTestAPI() {
        
        Task {
            guard let model = try? await apiService.requestA(CommunityManagerApi.MHouseholdList()) else { return }
            
            await MainActor.run {
//                self.cInfoViewModel = CommunityInfoViewModel(model)
            }
        }
    }
    
    func callAsyncAPI() {
        
        Task {
            do {
                async let sendAPI1 = apiService.requestA(CommunityManagerApi.PackagePlaceList())
                async let sendAPI2 = apiService.requestA(CommunityManagerApi.MHouseholdList())
                async let sendAPI3 = apiService.requestA(CommunityManagerApi.GeneratePackageID())
                async let sendAPI4 = apiService.requestA(CommunityManagerApi.CommunityInfoData())
                
                // 等待两个请求的结果
                let model1 = try await sendAPI1
                let model2 = try await sendAPI2
                let model3 = try await sendAPI3
                let model4 = try await sendAPI4
                
                await MainActor.run {
                    self.packagePlaceModels = model1
                    self.householdUserModels = model2.user
                    self.packageID = model3.id
                    self.cInfoViewModel = CommunityInfoViewModel(model4)
                    
                    self.pickerViewModel = PickerSelection(households: self.cInfoViewModel.houseHoldData)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func registerPackageAPI() {
        
        guard let packageID = self.packageID else { return }
        
        guard !self.recipient.isEmpty else { return }
        guard !self.packageType.isEmpty else { return }
        
        let other: String? = otherRecipient.isEmpty ? nil : otherRecipient
    
        let userList = householdUserModels.map { FacilityTypeModel(id: $0.id, name: $0.name, desc: $0.name) }
        
        
        Task {
            do {
                let _ = try await apiService.requestA(
                    CommunityManagerApi.RegisterPackage(
                        packageID: packageID,
                        recipient: recipient,
                        type: packageType,
                        other: other,
                        userList: userList
                    )
                )
            } catch {
                print(error)
            }
        }
    }
    
    func releaseAPI() {
        
        Task {
            guard let packageID = packageID else { return }
            do {
               let _ = try await apiService.requestARow(CommunityManagerApi.ReleasePackageID(id: packageID))
            } catch {
                print(error)
            }
        }
    }
    
    
}
