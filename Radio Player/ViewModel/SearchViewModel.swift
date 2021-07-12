//
//  SearchViewModel.swift
//  Open Movie Database
//
//  Created by Chandresh Kachariya on 03/06/21.
//

import Foundation

class SearchViewModel {
    
    public var PlayerList: [PlayerModel]? = nil
    public var RecentPlayerList: [PlayerModel]? = nil

    func fetchPlayerResults(apikey:String, completion: @escaping (_ result : String) -> Void, failure: @escaping (_ result : String) -> Void) {
        
        APIManager.shared.makeRequest(url: "/" + apikey, params: nil, withHttpMethod: .get) { (result: [PlayerModel]?) in
            if result?.count ?? 0 > 0 {
                self.PlayerList = nil
                self.PlayerList = result
                completion(Key.API.status.success.rawValue)
            } else {
                failure("Data not found")
            }
        }
        failure: { (error) in
            if let errorValue = error as? String {
                print(errorValue)
                failure(errorValue)
            }
        }
    }
    
    func fetchRecentPlayerResults(apikey:String, completion: @escaping (_ result : String) -> Void, failure: @escaping (_ result : String) -> Void) {
        
        APIManager.shared.makeRequest(url: "/" + apikey, params: nil, withHttpMethod: .get) { (result: [PlayerModel]?) in
            if result?.count ?? 0 > 0 {
                self.RecentPlayerList = nil
                self.RecentPlayerList = result
                completion(Key.API.status.success.rawValue)
            } else {
                failure("Data not found")
            }
        }
        failure: { (error) in
            if let errorValue = error as? String {
                print(errorValue)
                failure(errorValue)
            }
        }
    }
}

extension String {
    public func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespaces)
    }
}

