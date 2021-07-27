//
//  userModel.swift
//  GR
//
//  Created by 中森えみり on 2021/03/25.
//

import Foundation

struct userModel{
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]){
        self.name = dic["name"] as String
        self.createdAt = dic["createdAt"] as Timestamp
        self.email = dic["email"] as String
        
    }
}
