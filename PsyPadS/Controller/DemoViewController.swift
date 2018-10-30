//
//  DemoViewController.swift
//  PsyPad
//
//  Created by Roy Li on 28/08/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

class DemoViewController : UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Configurations") {
            let dest = segue.destination as? ConfigurationsTableViewController
            dest?.parentVC = self
        } else if (segue.identifier == "Test") {
            let controller = segue.destination as? TestViewController
            controller?.configurations = [sender]
        } else if (segue.identifier == "ShowLog") {
            let nav = segue.destination as? UINavigationController
            var vc = nav?.topViewController as? TestLogTableViewController
            // Currently not resolved it
            //vc?.log = sender
            vc?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: vc, action: #selector(TestLogTableViewController.pressedClose))
        }
    }
    
    @IBAction func tappedVisitWebsite(_ sender: UIButton) {
        if let aString = URL(string: "http://www.psypad.net.au/") {
            UIApplication.shared.openURL(aString)
        }
    }
}
