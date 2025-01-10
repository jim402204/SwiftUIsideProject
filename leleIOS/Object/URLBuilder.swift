//
//  URLBuilder.swift
//  leleIOS
//
//  Created by 江俊瑩 on 2025/1/10.
//

import Foundation

class URLBuilder {
    private let imageApiDomain: String
    static let defaultURL = URL(string: "www.google.com.tw")!
    
    
    init(imageApiDomain: String = "") {
        self.imageApiDomain = imageApiDomain
    }

    func buildURL(id: String, filepath: String) -> URL? {
        
        let info = UserDefaultsHelper.userBuilding
        let communityID = UserDefaultsHelper.communityAdmin
        let token = UserDefaultsHelper.token ?? ""
        let featurePath = filepath.firstPathComponent()?.withLowercasedFirstLetter() ?? ""
        
        let url = imageApiDomain + "/user/community/\(communityID)/\(featurePath)/\(id)/file?fn=\(filepath)&token=\(token)&b=\(info.building)&d=\(info.doorPlate)&f=\(info.floor)"

        return URL(string: url)
    }
    
    func build1URL(filepath: String) -> URL? {
        
        let imageApiDomain = "https://go.lelelink.com"
        
        let info = UserDefaultsHelper.userBuilding
        let communityID = UserDefaultsHelper.communityAdmin
        let token = UserDefaultsHelper.token ?? ""
        
        let url = imageApiDomain + "/user/community/\(communityID)/file?f=\(filepath)&token=\(token)&b=\(info.building)&d=\(info.doorPlate)&f=\(info.floor)"

        return URL(string: url)
    }
    
    func buildGoURL(supportDocsViewer: Bool = false, filepath: String) -> URL? {
        
        let communityID = UserDefaultsHelper.communityAdmin
        let token = UserDefaultsHelper.token ?? ""
        let imageApiDomain = "https://go.lelelink.com"
        
        var url = imageApiDomain + "/user/community/\(communityID)/file?f=\(filepath)&token=\(token)"
        
        if supportDocsViewer {
            let encodeURL = url.addingPercentEncoding(withAllowedCharacters: .strictUrlQueryAllowed) ?? ""
            //外部瀏覽器需要用google開
//            let googelDocsViewerUrl = "googlechrome://docs.google.com/viewer?url="
            let googelDocsViewerUrl = "https://docs.google.com/viewer?url="
            url = googelDocsViewerUrl + encodeURL
        }
        return URL(string: url)
    }
    
}

extension CharacterSet {
    static let strictUrlQueryAllowed: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "!*'();:@&=+$,/?%#[]")
        return allowed
    }()
}
