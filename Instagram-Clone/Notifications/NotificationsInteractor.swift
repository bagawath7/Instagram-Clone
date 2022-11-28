

import UIKit
import Firebase

protocol NotificationsBusinessLogic
{
    func fetchNotification()
    func fetchPost(withPost postId:String)

}



class NotificationsInteractor: NotificationsBusinessLogic
{
    func fetchPost(withPost postId: String) {
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else {return}
            self.presenter?.presentPost(snapshot: snapshot)
        }
    }
    
  var presenter: NotificationsPresentationLogic?
  
  
    func fetchNotification() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query =  COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").order(by: "timestamp",descending:true)
        
            query.getDocuments { snapshot, _ in
            
            self.presenter?.presentNotification(snapshot: snapshot)
            
        }
        
    }
    

   


    
}
