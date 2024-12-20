//
//  PostalServiceEntryViewModel.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2024/12/20.
//


import Observation
import Foundation

@Observable
class PostalServiceEntryViewModel {
    
    var model: GasHistoryModel? = nil
    var list: [GasHistoryModel] = []
    
    //    init() {
    //        callAsyncAPI()
    //    }
    
    var packageID: Int? = nil
    
    
    func callAPI() {
        
        Task {
            guard let models = try? await apiService.requestA(FeatureApi.GasHistory()) else { return }
            
            await MainActor.run {
                self.list = models
                self.model = models.first
            }
        }
    }
    
    func releaseAPI() {
        
        Task {
            guard let packageID = packageID else { return }
            do {
                try await apiService.requestARow(NotifyApi.ReleasePackageID(id: packageID))
            } catch {
                print(error)
            }
        }
    }


    
    func callAsyncAPI() {
        
        Task {
            do {
                async let model1 = apiService.requestARow(NotifyApi.PackagePlaceList())
                async let model2 = apiService.requestARow(NotifyApi.MHouseholdList())
                async let model3 = apiService.requestA(NotifyApi.GeneratePackageID())
                
                
                self.packageID = try await model3.id
                
                // 等待两个请求的结果
//                let result1 = try await model1.result
//                let result2 = try await model2.result
//                let combineResults = result1 + result2
//                let viewModels = combineResults.map { BulletinCellViewModel($0) }
                
                await MainActor.run {
//                    self.list = viewModels
                }
            } catch {
                print(error)
            }
        }
    }
}
