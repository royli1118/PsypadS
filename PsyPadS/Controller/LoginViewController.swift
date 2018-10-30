//
//  LoginViewController.swift
//  PsyPad
//
//  Created by Roy Li on 17/08/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation


class LoginViewController: MainMenuViewController {
    
    
    @IBOutlet weak var serverURLField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var centreView: UIView!
    var keyboardObserver: DLKeyboardObserver?
    var textFields: DLTextFieldCollection?
    var defaultCentreViewOffset: CGFloat = 0.0
    @IBOutlet weak var centreViewOffset: NSLayoutConstraint!

    override func viewDidLoad(){
        super.viewDidLoad()
        weak var weakSelf = self
        defaultCentreViewOffset = centreViewOffset.constant
        keyboardObserver = DLKeyboardObserver.init()
        keyboardObserver?.keyboardChanged = { visible, height in
            UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
                weakSelf?.centreViewOffset.constant = (weakSelf?.defaultCentreViewOffset)!
                if visible {
                    weakSelf?.centreViewOffset.constant = height / 2.0
                }
                weakSelf?.view.layoutIfNeeded()
            })
        }
        textFields = DLTextFieldCollection.init(textFields: [self.serverURLField, self.emailField, self.passwordField])
        textFields?.finalReturnBlock = {
            weakSelf?.login()
        }
    }
    
    @IBAction func login() {
        
        if !isValidEmail(email: (emailField.text)!) {
            let alert = UIAlertController(title: "Invalid Email", message: "The email address you entered is invalid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            return
        }
        if (passwordField.text?.count)! <= 0 {
            let alert = UIAlertController(title: "Missing Password", message: "Please enter your password to log in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            return
        }
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        weak var weakSelf = self
        let success: (() -> Void)? = {
            hud.hide(animated: true)
                weakSelf?.navigationController?.setViewControllers([DemoViewController.loadFromMainStoryboard()], animated: true)
            }
        let failure: ((_ error: String?) -> Void)? = { error in
                let alert = UIAlertController(title: "Log In Failed", message: error!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
            hud.hide(animated: true)
            }
        RootEntity().server_url = serverURLField.text!
        DatabaseManager.save()
        ServerManager.shared().login(withEmail: emailField.text, password: passwordField.text, success: success, failure: failure)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SignUp") {
            let nc = segue.destination as? UINavigationController
            let sutvc = nc?.viewControllers[0] as? SignUpTableViewController
            sutvc?.serverField.text = serverURLField.text ?? "https://www.psypad.net.au/server"
            sutvc?.emailField.text = emailField.text
            sutvc?.passwordField.text = passwordField.text
        }
    }
    
    @IBAction func tappedVisitWebsite(_ sender: UIButton) {
        if let aString = URL(string: "http://www.psypad.net.au/") {
            UIApplication.shared.openURL(aString)
        }
    }
    
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
}
