//
//  ResetPasswordWorker.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 28/11/22.
//

import Foundation
import Firebase
struct ResetPasswordWorker {
    
    static func resetPassword(withEmail email:String,completion:@escaping ((Error?)->Void)){
        Auth.auth().sendPasswordReset(withEmail: email,completion: completion)
        
    }
    
    
}
