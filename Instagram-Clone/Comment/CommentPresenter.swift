//
//  CommentPresenter.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 21/11/22.
//

import Foundation
import Firebase

protocol CommentPresentationLogic:AnyObject{
    func presentPosts(snapshot: QuerySnapshot)

    
}

class CommentPresenter:CommentPresentationLogic{
    

    
    weak var viewcontroller: CommentDisplayLogic?
    
    func presentPosts(snapshot: QuerySnapshot) {
        var comments = [Comment]()
        snapshot.documentChanges.forEach({ change in
            if change.type == .added{
                let data = change.document.data()
                let comment = Comment(dictionary: data)
                comments.append(comment)
            }
        })
        
        viewcontroller?.update(comments: comments)
    }
    
    
    
    
}
