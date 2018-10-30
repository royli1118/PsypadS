//
//  SignUpTableViewController.swift
//  PsyPad
//
//  Created by Roy Li on 07/09/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation


class SignUpTableViewController : UIViewController{
    
    @IBOutlet weak var serverField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var affiliationField: UITextField!
    @IBOutlet weak var signUpCell: UITableViewCell!
    var textFields: [Any] = []
    var toolbar: DLTextFieldToolbar?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.serverField.text = RootEntity().server_url
        self.textFields = [self.serverField,
                           self.emailField,
                           self.passwordField,
                           self.confirmPasswordField,
                           self.affiliationField]
        weak var weakSelf = self
        self.toolbar = DLTextFieldToolbar.init(textFields: self.textFields)
        self.toolbar?.finalReturnBlock = {
            weakSelf?.signUp()
        }
    }
    
    @IBAction func tappedClose(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    func signUp(){
        if !(passwordField.text == confirmPasswordField.text) {
            let alert = UIAlertController(title: "Password Mismatch", message: "The two passwords you entered do not match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            return
        }
        
        if (passwordField.text?.count)! <= 0 {
            let alert = UIAlertController(title: "Misisng Password", message: "Please choose a password to sign up with.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            return
        }
        if (affiliationField.text?.count)! <= 0 {
            let alert = UIAlertController(title: "Misisng Affiliation", message: "Please enter your academic affiliation (or \"None\").", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            return
        }
        var hud : MBProgressHUD?
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        weak var weakSelf = self
        var success: (() -> Void)? = {
            hud?.hide(animated: true)
            var lvc = (weakSelf?.navigationController?.presentingViewController as? UINavigationController)?.topViewController as? LoginViewController
            lvc?.serverURLField.text = weakSelf?.serverField.text
            lvc?.emailField.text = weakSelf?.emailField.text
            lvc?.passwordField.text = weakSelf?.passwordField.text
            weakSelf?.navigationController?.dismiss(animated: true) {
                    lvc?.login()
                }
        }
        
        var failure: ((_ error: String?) -> Void)? = { error in
            let alert = UIAlertController(title: "Sign Up Failed", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            hud?.hide(animated: true)
        }
        RootEntity().server_url = self.serverField.text!
        DatabaseManager.save()
        
        ServerManager.shared().signUp(withEmail: emailField.text, password: passwordField.text, info: ["affiliation": affiliationField.text], success: success, failure: failure)
    }
    
}


// MARK: TableView Delegate Function
extension SignUpTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) == self.signUpCell {
            self.signUp()
        }
    }
}
