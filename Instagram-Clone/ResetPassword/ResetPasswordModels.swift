//
//  ResetPasswordModels.swift

import UIKit

enum ResetPassword
{
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        
            var email:String?
             
            var formIsvalid:Bool {
                return email?.isEmpty == false 
                
            }
            var buttonBgColor:UIColor{
                return formIsvalid ? UIColor(red: 85/255, green: 145/255, blue: 232/255, alpha: 1) : UIColor(red: 22/255, green: 44/255, blue: 70/255, alpha: 0.5)
            }
            
            var buttomTitleColor:UIColor{
                return formIsvalid ? UIColor.white : UIColor.white.withAlphaComponent(0.3)
            }
    }
  }

