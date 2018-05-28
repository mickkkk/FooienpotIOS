//
//  Tip.swift
//  Fooienpot-IOS
//
//  Created by Fhict on 09/01/2018.
//  Copyright © 2018 Mick. All rights reserved.
//

import Foundation

class Tip {
    var amount = ""
    var department = ""
    var comment = ""
    
    init(a:String, d:String, c:String){
        self.amount = a
        self.department = d
        self.comment = c
    }
    
    init(a:String) {
        self.amount = a
        //self.department = "Both"
        //self.comment = ""
    }
    
    
    func setAmount(a:String) {
        self.amount = a
    }
    
    func setDepartment(d:String) {
        self.department = d
    }
    
    func setComment(c:String) {
        self.comment = c
    }
    
    func getAmount() ->String {
        return self.amount
    }
    
    func getDepartment() ->String {
        return self.department
    }
    
    func getComment() ->String {
        return self.comment
    }
    
}
