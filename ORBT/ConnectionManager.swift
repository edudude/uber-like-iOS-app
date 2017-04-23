//
//  ConnectionManager.swift
//  QuantumListing
//
//  Created by lucky clover on 3/25/17.
//  Copyright © 2017 lucky clover. All rights reserved.
//

import Foundation
import AFNetworking

//let BASE_URL = "http://192.168.1.146:3000"
let BASE_URL = "https://calm-fortress-15437.herokuapp.com"

class ConnectionManager : AFHTTPSessionManager{
    
    class func sharedClient() -> ConnectionManager {
        var _sharedClient: ConnectionManager? = nil
        var onceToken = 0
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            //        _sharedClient = [[ConnectionManager alloc] initWithBaseURL:[NSURL URLWithString:AFSecomeaAPIBaseURLString]];
            _sharedClient = ConnectionManager()
            _sharedClient?.securityPolicy.allowInvalidCertificates = true
            _sharedClient?.responseSerializer = AFHTTPResponseSerializer()
            _sharedClient?.requestSerializer = AFHTTPRequestSerializer()
        }
        onceToken = 1
        return _sharedClient!
    }
}
