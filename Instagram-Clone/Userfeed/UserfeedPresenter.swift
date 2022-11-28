//
//  UserfeedPresenter.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import Foundation
import Firebase

protocol UserfeedPresentationLogic:AnyObject{

    func presentPosts(snapshot: [QueryDocumentSnapshot])
    
    func presentLikes(snapshot: DocumentSnapshot,post:UserfeedModel.ViewModel.Post)
}

class UserfeedPresenter:UserfeedPresentationLogic{
    func presentLikes(snapshot: DocumentSnapshot, post: UserfeedModel.ViewModel.Post) {
        print(snapshot.exists)
        viewcontroller.updateLikes(isLiked: snapshot.exists,post: post)
    }
   
    
    func presentPosts(snapshot: [QueryDocumentSnapshot]) {
        let posts = snapshot.map { UserfeedModel.ViewModel.Post(postId: $0.documentID, dictionary: $0.data())
        }
        viewcontroller.update(posts: posts)
    }
    
    

  weak var viewcontroller:UserfeedDisplayLogic!
    
}
