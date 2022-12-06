//
//  ProfileViewModel.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 07/11/22.
//

import Foundation
import Firebase
struct UserModel{
    
    struct FetchResponse{
        struct userdata{
            var snapshot : DocumentSnapshot
        }
    }
    
    
    struct ViewModel {
        struct StatsViewModel{
            let followers: Int
            let following: Int
            let posts:Int
        }
        struct User{
            let email:String
            var fullname:String
            var username:String
            var profileImageUrl:String
            let uid: String
            var bio:String?
            
            var isCurrentUser:Bool{
                return Auth.auth().currentUser?.uid == uid
                
            }
            var isFollowed = false
            var stats: StatsViewModel!
            
        }
        
        
        
    }
    
}

extension UserModel.ViewModel.User{
    
    init(dictionary:[String:Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.stats = UserModel.ViewModel.StatsViewModel(followers: 0, following: 0,posts: 0)

    }
}
