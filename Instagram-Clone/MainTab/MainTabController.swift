//
//  MainTabController.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 08/11/22.
//


import UIKit
import Firebase
import YPImagePicker
protocol MainTabDisplayLogic:AnyObject{
    func update(user: UserModel.ViewModel.User)
}
class MainTabController: UITabBarController {
    
    var intractor:MainTabBussinessLogic!
    var user:UserModel.ViewModel.User?{
        didSet{
            if let user = user {
                configureViewControllers(withUser: user)
            }
          
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        do{
//            try Auth.auth().signOut()
//        }catch{
//            print("Error ion sign out")
//        }
        setup()
        checkIfUserIsLoggedIn()
    
        
    }
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let controller = LoginViewController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: true)
            }
          
        }
    }
    func setup(){
        
        let intractor = MainTabIntractor()
        let presenter = MainTabPresenter()
        
        intractor.presenter = presenter
        self.intractor = intractor
        presenter.viewcontroller = self
        
        intractor.fetchuser()
        
        self.tabBar.isTranslucent = false
    }
    func configureViewControllers(withUser user:UserModel.ViewModel.User){
        view.backgroundColor = .white
        self.delegate = self
        tabBar.tintColor = .black
        let layout = UICollectionViewFlowLayout()
        let feed = UINavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: UserfeedViewController(collectionViewLayout: layout))
        let search = UINavigationController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchController())
        let imageSelector = UINavigationController(unselectedImage: UIImage(named:  "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: UIViewController())
        let notifications = UINavigationController(unselectedImage: UIImage(named:"like_unselected" )!, selectedImage: UIImage(named: "like_selected")!, rootViewController:NotificationsViewController())
        let profile = UINavigationController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: ProfileViewController(user: user))
        
        viewControllers = [feed,search,imageSelector,notifications,profile]
        
    }
    
 
    
    
}


extension UINavigationController{
    
    
    convenience init(unselectedImage:UIImage,selectedImage:UIImage,rootViewController: UIViewController){
        self.init(rootViewController: rootViewController)
        tabBarItem.image = unselectedImage
        tabBarItem.selectedImage = selectedImage
        navigationBar.tintColor = .black

    }
    
    
}



extension MainTabController:MainTabDisplayLogic{
    func update(user: UserModel.ViewModel.User) {
        self.user = user
    }
    
   
    
    
}

extension MainTabController:AuthenticationDelegate{
    func authenticationDidComplete() {
        intractor.fetchuser()
        dismiss(animated: true)
    }
    
    func didFinishPickingMedia(_ picker:YPImagePicker){
        picker.didFinishPicking { items, cancelled in
            
            if cancelled{
                self.selectedIndex = 0
                self.dismiss(animated: true)
            }
            picker.dismiss(animated: false){
                guard let selectedImage = items.singlePhoto?.image else {return }
               
                
                let controller = UploadPostController()
                controller.currentUser = self.user
                controller.delegate = self
                controller.selectedImage = selectedImage
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
                
            }
            
        }
        
        
    }
}

extension MainTabController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2{
            var config = YPImagePickerConfiguration()
            config.library.mediaType = YPlibraryMediaType.photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = YPPickerScreen.library
            config.screens = [.library, .photo]
            config.hidesBottomBar = false
            config.hidesStatusBar = false
            config.library.maxNumberOfItems = 3
            
            let picker = YPImagePicker(configuration: config)
            picker.toolbar.tintColor = .black
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            didFinishPickingMedia(picker)
            
            
            
            
        }
        return true
    }
    
}
//MARK: UploadPostControllerDelegate
extension MainTabController: UploadPostControllerDelegate{
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        
        controller.dismiss(animated: true)

    }
    
    
    
}
