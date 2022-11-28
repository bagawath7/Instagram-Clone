

import UIKit

protocol ResetPasswordDisplayLogic:AnyObject
{
}

protocol ResetPasswordControllerDelegate:AnyObject{
    func controllerDidSendResetPasswordLink(_ controller:ResetPasswordController)
}

class ResetPasswordController: UIViewController, ResetPasswordDisplayLogic{
    
    var interactor: ResetPasswordBusinessLogic?
    weak var delegate:ResetPasswordControllerDelegate?
    
    var  email: String?
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let iconImage = UIImageView(image:UIImage(named: "Instagram_logo_white"))
    private var viewModel = ResetPassword.ViewModel()
    
    
   private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 22/255, green: 44/255, blue: 70/255, alpha: 0.5)
        
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleResetPassword) , for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for:  .normal)
        button.addTarget(self, action: #selector(handleDismissal) , for: .touchUpInside)

        
        
        return button
    }()

    override func viewDidLoad()
    {
      super.viewDidLoad()
      setup()
      configureUI()

    }

  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ResetPasswordInteractor()
    let presenter = ResetPasswordPresenter()
    viewController.interactor = interactor
    interactor.presenter = presenter
    presenter.viewController = viewController
  }
    
    
    private func configureUI(){
        view.backgroundColor = .black
        
        emailTextField.text = email
        updateform()
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leadingAnchor,
        paddingTop: 16,paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.contentMode = .scaleAspectFill
        iconImage.centerX(inView: self.view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        let stack = UIStackView(arrangedSubviews: [emailTextField,resetButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        
        stack.anchor(top: iconImage.bottomAnchor,left: view.leadingAnchor,right: view.trailingAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        
        
    }
    
    
     @objc private func handleResetPassword(){
         guard let email = emailTextField.text else {return}
         showloader(true)
         ResetPasswordWorker.resetPassword(withEmail: email) { error in
             if let error = error {
                 self.showMessage(withTitle: "Error", message: error.localizedDescription)
                 
                 print(error.localizedDescription)
                 self.showloader(false)
                 return
             }
             
             self.delegate?.controllerDidSendResetPasswordLink(self)
         }
         
    }
    
    @objc private func handleDismissal(){
        navigationController?.popViewController(animated: true)
   }
}

extension ResetPasswordController{
    
    @objc func textDidChange(sender:UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }
        if(viewModel.formIsvalid){
            resetButton.isEnabled = true
        }else{
            resetButton.isEnabled = false

        }
        updateform()
        
    }
    
 func updateform(){
        resetButton.backgroundColor = viewModel.buttonBgColor
        resetButton.setTitleColor(viewModel.buttomTitleColor, for: .normal)
    }
    
    
    
    
}

