//
//  APICommunicator.swift
//  Flipsz
//
//  Created by Gregory Lammers on 13-11-17.
//  Copyright © 2017 Flipsz Students. All rights reserved.
//

//
//  APICommunicator.swift
//  companion
//
//  Created by Gregory Lammers on 17-03-17.
//  Copyright © 2017 Gregory Lammers. All rights reserved.
//

import Alamofire
import UIKit

class APICommunicator: NSObject {
    
    //Class variables
    struct Settings {
        static let baseUrl: String = "https://gregory-bakery-api.herokuapp.com"
        static let restUrl: String = NSString(format: "%@", baseUrl) as String
    }
    
    static var sessionManager = SessionManager()
    
    //Functions
    class func executePost(_ url: String, parameters: NSDictionary, succes: @escaping ((_ json: AnyObject) -> Void), failed: @escaping ((_ error: NSError) -> Void)) {
        
        let fullUrl = Settings.restUrl + url
        let params = parameters as! Parameters
        
        Alamofire.request(fullUrl, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                // Get response statusCode
                let statusCode: Int = response.response?.statusCode != nil ? response.response!.statusCode : 0
                // Check if request succeeded (code 201)
                // If true: return json
                // Else:    return error
                if (statusCode == 200) {
                    succes(response.result.value as AnyObject)
                }
                else {
                    
                    // Check if response error exists
                    // If true: return existing error (code 500)
                    // Else:    created error en return this error (code 401, 403 etc.)
                    if (response.result.error != nil) {
                        failed(response.result.error! as NSError)
                    }
                    else {
                        let test = NSError(domain: response.request!.url!.absoluteString, code: statusCode, userInfo: response.result.value! as? [AnyHashable: Any] as? [String : Any])
                        failed(test)
                    }
                }
        }
    }
    
    class func executeGetImage(_ url: String, succes: @escaping ((_ image: UIImage?) -> Void), failed: @escaping ((_ error: NSError) -> Void)) {
//            sessionManager.adapter = AccessTokenAdapter(accessToken: credentials)
        
                Alamofire.request(url)
                    .responseData{ response in
                        
                        if let hallo = response.data {
                            let img = UIImage(data: hallo)
//                            print(UIImage(data: image))
                            succes(img)
                        } else {
                            failed(response.result.error! as NSError)
                        }
                }
        }
    
    class func executeBearerAuthGet(_ url: String, credentials: String, succes: @escaping ((_ json: AnyObject) -> Void), failed: @escaping ((_ error: NSError) -> Void)) {
        
        sessionManager.adapter = BearerTokenAdapter(bearerToken: credentials)
        
        let fullUrl = Settings.restUrl + url
        
        sessionManager.request(fullUrl, encoding: JSONEncoding.default)
            .responseJSON { response in
                // Get response statusCode
                let statusCode: Int = response.response?.statusCode != nil ? response.response!.statusCode : 0
                // Check if request succeeded (code 200)
                // If true: return json
                // Else:    return error
                if (statusCode == 200) {
                    succes(response.result.value! as AnyObject)
                }
                else {
                    
                    // Check if response error exists
                    // If true: return existing error (code 500)
                    // Else:    created error en return this error (code 401, 403 etc.)
                    if (response.result.error != nil) {
                        failed(response.result.error! as NSError)
                    }
                    else {
                        let test = NSError(domain: response.request!.url!.absoluteString, code: statusCode, userInfo: response.result.value! as? [AnyHashable: Any] as? [String : Any])
                        failed(test)
                        
                    }
                }
        }
    }
    
    class func executeAuthPost(_ url: String, credentials: String, parameters: NSDictionary, succes: @escaping ((_ json: AnyObject) -> Void), failed: @escaping ((_ error: NSError) -> Void)) {
        
        sessionManager.adapter = BearerTokenAdapter(bearerToken: credentials)
        
        let fullUrl = Settings.restUrl + url
        let params = parameters as! Parameters
        
        sessionManager.request(fullUrl, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                // Get response statusCode
                let statusCode: Int = response.response?.statusCode != nil ? response.response!.statusCode : 0
                
                // Check if request succeeded (code 201)
                // If true: return json
                // Else:    return error
                if (statusCode == 200) {
                    succes(response.result.value! as AnyObject)
                }
                else {
                    
                    // Check if response error exists
                    // If true: return existing error (code 500)
                    // Else:    created error en return this error (code 401, 403 etc.)
                    if (response.result.error != nil) {
                        failed(response.result.error! as NSError)
                    }
                    else {
                        let test = NSError(domain: response.request!.url!.absoluteString, code: statusCode, userInfo: response.result.value! as? [AnyHashable: Any] as? [String : Any])
                        failed(test)
                        
                    }
                }
        }
    }
    
    class func executeFileUpload(_ url: String, amount: String, department: String, comment: String, succes: @escaping ((_ json: AnyObject) -> Void), failed: @escaping ((_ error: NSError) -> Void)) {
        
//        sessionManager.adapter = BearerTokenAdapter(bearerToken: credentials)
        
        let fullUrl = Settings.restUrl + url
        
        let amount = amount.data(using: String.Encoding.utf8)
        let department = department.data(using: String.Encoding.utf8)
        let comment = comment.data(using: String.Encoding.utf8)

        sessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(amount!, withName: "amount")
            multipartFormData.append(department!, withName: "department")
            multipartFormData.append(comment!, withName: "comment")
        }, to: fullUrl) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if let response = response.value as? [String: AnyObject] {
                        if let messages = response["messages"] as? NSDictionary {
                            
                            /*let message = messages["email"] as? NSArray
                            if (message![0] as? String == "The email has already been taken.") {
                                failed(NSError(domain: "test", code: 400, userInfo: ["error": "The email has already been taken."]));*/
                            }
                        }else{
                            succes(response as AnyObject)
                        }
                    }
            case .failure(_):
                failed(NSError(domain: "test", code: 400, userInfo: ["error": "Tip failed."]))
            }
            /*case .failure(let encodingError):
                failed(NSError(domain: "test", code: 400, userInfo: ["error": "Could not register."]))
            }*/
        }
    }
    /*
    class func executeFileUpload(_ url: String, media: [Data], group_id: String, logbook_group_id: String, title: String, description: String, credentials: String, succes: @escaping ((_ json: AnyObject) -> Void), failed: ((_ error: NSError) -> Void)) {
        
        sessionManager.adapter = BearerTokenAdapter(bearerToken: credentials)
        
        let fullUrl = Settings.restUrl + url
        let groupid = group_id.data(using: .utf8)
        let logbook_group_id = logbook_group_id.data(using: .utf8)
        let title = title.data(using: .utf8)
        let description = description.data(using: .utf8)
        
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            for (attachment, med) in media.enumerated() {
                let att = attachment + 1
                //                print("Item \("attachement" + String(att)): \(med)")
                multipartFormData.append(med, withName: "attachement" + String(att), fileName: "myImage.jpeg", mimeType: "image/jpeg")
            }
            multipartFormData.append(groupid!, withName: "group_id")
            multipartFormData.append(logbook_group_id!, withName: "logbook_group_id")
            multipartFormData.append(title!, withName: "title")
            multipartFormData.append(description!, withName: "description")
        }, to: fullUrl) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    print("TEST: Response \(response)")
                    succes(response.result.value! as AnyObject)
                }
            case .failure(let encodingError):
                print(encodingError)
                // TODO: Handle error
                //failed(error: response.result.error!)
            }
            
        }
        
    }*/
}

