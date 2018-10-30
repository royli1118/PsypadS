//
//  LaunchViewController.swift
//  PsyPad
//
//  Created by Roy Li on 27/08/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation


class LaunchViewController: DLLaunchViewController {
     override func handleLaunch() {
        super.handleLaunch()
        var rootEntity : RootEntity?
        if (rootEntity?.server_url == "http://server.psypad.net.au/") {
            rootEntity?.server_url = "https://server.psypad.net.au/"
            DatabaseManager.save()
        }
        var vc : UIViewController
        if rootEntity?.loggedIn() == true {
            if rootEntity?.demoModeValue == true {
                vc = DemoViewController.loadFromMainStoryboard()
            }
            else{
                vc = MainMenuViewController.loadFromMainStoryboard()
            }
        }
        else{
            vc = LoginViewController.loadFromMainStoryboard()
        }
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    @IBAction func tappedVisitWebsite(_ sender: UIButton) {
        if let aString = URL(string: "http://www.psypad.net.au/") {
            UIApplication.shared.openURL(aString)
        }
    }
    
}
