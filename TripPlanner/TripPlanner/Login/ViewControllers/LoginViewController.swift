//
//  RELoginViewControllerSwift.swift
//  ResQ
//
//  Created by Eliel Gordon on 8/31/15.
//

import UIKit
import QuartzCore
import SVProgressHUD
import SwiftyJSON


class LoginViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var userNameTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var inputContainerCenterConstraint : NSLayoutConstraint!
    @IBOutlet weak var loginButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the login button till there is input for username and password
//        loginButton(false)
        
        
//        userNameTextField.addTarget(self, action: "textFieldDidChangeAnimation", forControlEvents: UIControlEvents.EditingChanged)
//        passwordTextField.addTarget(self, action: "textFieldDidChangeAnimation", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    /**
    Determines whether the login button should be enabled or disabled.
    
    - parameter enabled: - A boolean of the state of the login button.
    */
    func loginButton(enabled: Bool) -> ()
    {
        func enable()
        {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations:
                {
                    self.loginButton.backgroundColor = UIColor(red: 10/255, green: 101/255, blue: 172/255, alpha: 1.0)
                }, completion: nil)
            
            loginButton.enabled = true
        }
        func disable()
        {
            loginButton.enabled = false
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:
                {
                    self.loginButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
                }, completion: nil)
        }
        return enabled ? enable() : disable()
    }
    
    // Resign the keyboard when user touches anything other than the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        view.endEditing(true)
        moveInputContainer(false)
    }
    
    /*
     Logs in a user from the REST API
    */
    func loginUser() {
        SVProgressHUD.showWithStatus("Logging In", maskType: .Black)
        AuthenticationAPIClient.sharedInstance.loginWithUsernameInBackground(username: userNameTextField.text!, password: passwordTextField.text!) {
            (message: String) -> Void in
            print(message)
            self.moveToTabBarController()
        }
        SVProgressHUD.dismiss()
        
    }
    // MARK: Login Action
    @IBAction func loginPressed(sender: AnyObject) {

        loginUser()
    }
    
    @IBAction func unwindSignUp(segue: UIStoryboardSegue, sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func moveToTabBarController() {
        dispatch_async(dispatch_get_main_queue())  {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("PlannedTripsNav") as! UINavigationController
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController

        }
        
    }
    
    /**
    Prefer the status bar to be hidden
    
    - returns: true -> we want a hidden status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

// MARK: - UITextField Delegate & Helpers

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Move the input container containing all the textfields up for convienience
        moveInputContainer(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            
            moveInputContainer(false)
            textField.resignFirstResponder()
        }
        return false
    }
    
    /**
    Helper method that moves the container view for the uitextfields
    */
    func moveInputContainer(moveUp: Bool) {
        
        if moveUp {
            
            // Move TextFields up
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.inputContainerCenterConstraint.constant = 100
                self.view.layoutIfNeeded()
                
                }, completion: nil)
            
        } else {
            
            // Move TextFields down
            UIView.animateWithDuration(0.3) {
                self.inputContainerCenterConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    /**
    Enables or disables the login button, based on text entry
    */
    func textFieldDidChangeAnimation()
    {
        if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty
        {
            self.loginButton(false)
        }
        else
        {
            self.loginButton(true)
        }
    }
}
