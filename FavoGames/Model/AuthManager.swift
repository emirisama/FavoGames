//
//  AuthManager.swift
//  FavoGames
//
//  Created by 中森えみり on 2021/08/14.
//

import Foundation
import Firebase
import PKHUD

protocol SendProfileDataProtocol {
    
    func catchProfileData()
    
}

class AuthManager: SendProfileDone{
    
    static let shared = AuthManager()
    var sendDBModel = SendDBModel()
    var sendProfileDataProtocol: SendProfileDataProtocol?
    
    func signIn(userName: String){
        
        sendDBModel.sendProfileDone = self
        
        Auth.auth().signInAnonymously { [self] result, error in
            
            if error != nil {
                
                return
                
            } else {
                
                let usernoimage = UIImage(named: "userimage")
                let usernoimagedata = usernoimage?.jpegData(compressionQuality: 1)
                sendDBModel.sendProfile(userName: userName, imageData: usernoimagedata!)
                
            }
        }
    }
    
    func signOut() {
        
        do {
            
            try Auth.auth().signOut()
            
        } catch {
            
        }
        
    }
    
    func checkProfileDone() {

        sendProfileDataProtocol?.catchProfileData()
        
    }
    
    
}
