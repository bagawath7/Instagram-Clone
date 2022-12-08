//
//  UploadPostControllerViewController.swift
//  Instagram-Clone
//
//  Created by zs-mac-4 on 11/11/22.
//

import UIKit
 
protocol UploadPostControllerDelegate: AnyObject{
    
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
    
}

class UploadPostController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confiureUI()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    weak var delegate: UploadPostControllerDelegate?
    
    //MARK: Properties
    
    var currentUser: UserModel.ViewModel.User?
    
    var selectedImage:UIImage?{
        didSet{
            photoImageView.image = selectedImage
        }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
        
    }()
    
    private lazy var captionTextView:InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter Caption..."
        tv.delegate = self
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.placeholderShouldCenter = false
        
        return tv
    }()
    
    private let characterCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    //MARK: Actions
    
    @objc func didTapCancel(){
        
        delegate?.controllerDidFinishUploadingPost(self)    }
    
    @objc func didTapDone(){
        guard let image = selectedImage else{return}
        guard let caption = captionTextView.text else {return}
        guard let user = currentUser else {return}
        showloader(true)
        
        
        PostWorker.uploadPost(caption: caption, image: image, user:user) { error in
            self.delegate?.controllerDidFinishUploadingPost(self)
            self.showloader(false)
            if let  error = error{
                print("Debug: Failed to upload post\(error.localizedDescription)")
                return
            }
        }
        
        
    }
   
    
    //MARK: Helper
    
    func checkMaxLength(_ textView: UITextView, maxLength:Int){
        if (textView.text.count) > maxLength {
            textView.deleteBackward()
        }
    }
    
    //MARK: UI
    
    func confiureUI(){
        
        view.backgroundColor = .white
        
        navigationItem.title = "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 16)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor,left: view.leadingAnchor,
                               right: view.trailingAnchor,paddingTop: 16,paddingLeft: 12,
        paddingRight: 12,height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor,right: view.trailingAnchor,paddingBottom: -8,paddingRight: 12)
        
    }
}

//MARK: UITextFieldDelegate

extension UploadPostController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let maxLength = 100
        checkMaxLength(textView, maxLength: maxLength)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/\(maxLength)"
        
        captionTextView.placeholderLabel.isHidden = !captionTextView.text.isEmpty
    }
}
