//
//  webimModels.swift
//  Nett
//
//  Created by WeBIM RD on 2016/6/24.
//  Copyright © 2016 WeBIM Services. All rights reserved.
//

import Foundation

// 建立"UserData"的類別, 描述UserData會有什麼"參數"與"方法"
class UserData {
    
    var UserID: Int!
    var Name: String!
    var Unit: String?
    var Title: String?
    var CompanyID: Int!
    var Email: String!
    var AccessToken: String!
    
//    func copy() -> AnyObject! {
//        if let asCopying = ((self as AnyObject) as? NSCopying) {
//            return asCopying.copyWithZone(nil)
//        } else {
//            assert(false, "This class doesn't implement NSCopying")
//            return nil
//        }
//    }
//    
//    func copyWithZone(zone: NSZone) -> AnyObject! {
//        let newValue = UserData()
//        newValue.UserID = UserID
//        newValue.Name = Name
//        newValue.Unit = Unit
//        newValue.Title = Title
//        newValue.CompanyID = CompanyID
//        newValue.Email = Email
//        newValue.AccessToken = AccessToken
//        return newValue
//    }
}


