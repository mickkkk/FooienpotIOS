//
//  BearerTokenAdapter.swift
//  Flipsz
//
//  Created by Gregory Lammers on 13-11-17.
//  Copyright © 2017 Flipsz Students. All rights reserved.
//

import Alamofire

class BearerTokenAdapter: RequestAdapter {
    private let bearerToken: String
    
    init(bearerToken: String) {
        self.bearerToken = "Bearer " + bearerToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
