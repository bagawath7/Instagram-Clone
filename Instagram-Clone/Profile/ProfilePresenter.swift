//
//  ProfilePresentor.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 07/11/22.
//

import Foundation
import Firebase
protocol ProfilePresentationLogic:AnyObject{
    func presentProfile(followerSnapshot: QuerySnapshot?,followingSnapshot:QuerySnapshot?,postsSnapshot:QuerySnapshot?)
    func presentPosts(snapshot: [QueryDocumentSnapshot])

}

class ProfilePresenter:ProfilePresentationLogic{
    func presentProfile(followerSnapshot: QuerySnapshot?, followingSnapshot: QuerySnapshot?,postsSnapshot:QuerySnapshot?) {
        let followers =  followerSnapshot?.documents.count ?? 0
        let following =  followingSnapshot?.documents.count ?? 0
        var posts = postsSnapshot?.documents.count ?? 0
        
       let stats = UserModel.ViewModel.StatsViewModel(followers: followers, following: following,posts: posts)
       
       viewcontroller?.update(stats: stats)
    }
    
    func presentPosts(snapshot: [QueryDocumentSnapshot]) {
        var posts = snapshot.map { UserfeedModel.ViewModel.Post(postId: $0.documentID, dictionary: $0.data())
            }
        posts.sort { $0.timestamp.seconds > $1.timestamp.seconds
        }
            viewcontroller?.update(posts: posts)
        }
    weak var viewcontroller:ProfileDisplayLogic?

    }
   
    
   

 
    
    
    

