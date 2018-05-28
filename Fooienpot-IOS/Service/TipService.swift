//
//  TipService.swift
//  Fooienpot-IOS
//
//  Created by Fhict on 10/01/2018.
//  Copyright © 2018 Mick. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TipService {
    
    func tipPost(amount: String, department: String, comment: String, succes: @escaping ((_ succes: Tip) -> Void), failed: @escaping ((_ error: String) -> Void)) {
        let url = "/tip"
        let dict: NSDictionary = ["amount" : amount, "department" : department, "comment" : comment]
        
        
        APICommunicator.executePost(url, parameters: dict, succes: { (json) in
            let parsedJSON = JSON(json)
            let tip = Tip(a: parsedJSON["success"]["amount"].stringValue,
                          d: parsedJSON["success"]["department"].stringValue,
                          c: parsedJSON["success"]["comment"].stringValue)
            succes(tip)
        }) { (error) in
            failed(error.localizedDescription)
        }
    }
}
