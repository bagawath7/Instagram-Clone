//
//  CommentIntractor.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 21/11/22.
//

import Foundation
import Firebase

protocol CommentBusinessLogic:AnyObject{
    
    func fetchComments(forPost postID: String)
    
}

class CommentIntractor:CommentBusinessLogic{
    func fetchComments(forPost postID: String){
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by:"timestamp" ,descending: true)
        query.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot{
                self.presenter.presentPosts(snapshot: snapshot)
            }
            
            
                    }
    }
    
    
    
    var presenter:CommentPresentationLogic!
}
