//
//  ProfileIntractor.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 07/11/22.
//

import Foundation
import Firebase



protocol ProfileBussinessLogic:AnyObject{
   
    func fetchUserStats(uid:String)
    func fetchPosts(forUser uid:String)
    
}

class ProfileIntractor:ProfileBussinessLogic{
    
    var presenter:ProfilePresentationLogic!
    
    func fetchPosts(forUser uid:String){
        COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            self.presenter.presentPosts(snapshot: documents)
//            documents.forEach { doc in
//                print(doc.data())
//            }
        }
    }

    
    func fetchUserStats(uid:String){
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot,_ ) in
            let followers = snapshot
//            let followers = snapshot?.documents.count ?? 0
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot,_ ) in
                let following = snapshot
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
                    
                    let posts = snapshot
                    
                    self.presenter.presentProfile(followerSnapshot: followers, followingSnapshot: following,postsSnapshot:posts)
                }
               
            }
            
            
            
            
        }
        
        
        
        
        
        
    }
}
