

import UIKit
import Firebase

protocol NotificationsPresentationLogic{
    func presentNotification(snapshot: QuerySnapshot?)
    func presentPost(snapshot:DocumentSnapshot)

}

class NotificationsPresenter: NotificationsPresentationLogic{
    func presentPost(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else{return}
        let post = UserfeedModel.ViewModel.Post(postId: snapshot.documentID, dictionary: data)
        viewController?.ViewPostInUserFeedController(post: post)
    }
    
    func presentNotification(snapshot: QuerySnapshot?) {
        guard let documents = snapshot?.documents else {return}
        let notifications = documents.map ({ Notification(dictionary: $0.data())})
            
            self.viewController?.updatenotifications(notifications: notifications)
        }
    
    
    
        
  weak var viewController: NotificationsDisplayLogic?
  
  

}
