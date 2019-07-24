//
//  NetworkUtils.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/20.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import Alamofire
class NetworkUtils{
    
    static let baseURL:String = "http://101.132.185.90:5418"
    
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    init?(){}
    
    public static func postRequest(method:String,parameters:Parameters,header:HTTPHeaders?)->DataRequest{
        let urlStr = baseURL + method
        return header != nil ? sharedSessionManager.request(urlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header) : sharedSessionManager.request(urlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    public static func getRequest(method:String,parameters:Parameters?,header:HTTPHeaders?)->DataRequest{
        let urlStr = baseURL + method
        return header != nil ? parameters != nil ? sharedSessionManager.request(urlStr, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: header) : sharedSessionManager.request(urlStr, method: .get, encoding: JSONEncoding.default, headers: header): parameters != nil ? sharedSessionManager.request(urlStr, method: .get, parameters: parameters, encoding: JSONEncoding.default) : sharedSessionManager.request(urlStr, method: .get, encoding: JSONEncoding.default)
    }
}
