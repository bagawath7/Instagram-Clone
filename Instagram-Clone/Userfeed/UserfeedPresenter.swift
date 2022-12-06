//
//  UserfeedPresenter.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import Foundation
import Firebase

protocol UserfeedPresentationLogic:AnyObject{

    func presentPosts(snapshot: [UserfeedModel.FetchResponse.postdata])
    
    func presentLikes(snapshot: UserfeedModel.FetchResponse.postdata,post:UserfeedModel.ViewModel.Post)
}

class UserfeedPresenter:UserfeedPresentationLogic{
    
    func presentPosts(snapshot: [UserfeedModel.FetchResponse.postdata]) {
        var posts = [UserfeedModel.ViewModel.Post]()

        snapshot.forEach { postData in
            guard let data = postData.snapshot.data() else{return}
            let post = UserfeedModel.ViewModel.Post(postId: postData.snapshot.documentID, dictionary: data)
                posts.append(post)
        }
        posts.sort { $0.timestamp.seconds > $1.timestamp.seconds }
        viewcontroller.update(posts: posts)
        
        
    }
    
    func presentLikes(snapshot: UserfeedModel.FetchResponse.postdata, post: UserfeedModel.ViewModel.Post) {
        
        viewcontroller.updateLikes(isLiked: snapshot.snapshot.exists,post: post)
    }
    
   
    
   
  weak var viewcontroller:UserfeedDisplayLogic!
    
}
