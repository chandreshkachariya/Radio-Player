//
//  APIManager.swift
//  Open Movie Database
//
//  Created by Chandresh Kachariya on 03/06/21.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON

enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class APIManager: Session {
    static let shared = APIManager(configuration: APIManager.urlSessionConfiguration(), serverTrustManager: nil)
    var activityIndictor: UIActivityIndicatorView?
    var activityIndicatorView: UIView?
    
    let base_url = "https://api.itmwpb.com/nowplaying/v3/935"
    
    static func urlSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpCookieStorage = nil
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        return configuration
    }
    
    func getHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "accept": "application/json"
        ]
        return headers
    }
        
    func cancelAFRequest(_ url: String) {
        AF.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            for item in dataTasks {
                if let urlValue = item.currentRequest?.url?.absoluteString {
                    if urlValue.contains(url) {
                        item.cancel()
                        print("cancelAFRequest")
                    }
                }
            }
        }
    }
    
    func makeRequest<T: Decodable>(url: String, params: [String: Any]?, withHttpMethod: HttpMethod, completion:@escaping (_ result : T?) -> Void, failure: @escaping (_ result : Any?) -> Void) {
        if !Connectivity.isConnectedToInternet() {
            failure("No internet connection")
            return
        }
        
        // Set api url
        let api_url = base_url + url
        
        // Make Network API Call
        AF.request(api_url, method: HTTPMethod(rawValue: withHttpMethod.rawValue) , parameters: params, headers: getHeader())
            .responseJSON(completionHandler: { response in
                debugPrint(response);
                switch response.result {
                case .success(let value):
                    do {
                        let json = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let result = try JSONDecoder().decode(T.self, from: json)
                        completion(result)
                    }
                    catch {
                        debugPrint(error)
                        failure(error)
                    }
                case .failure(let error):
                    print(error)
                    failure(error.localizedDescription)
                }
            })
    }
}
