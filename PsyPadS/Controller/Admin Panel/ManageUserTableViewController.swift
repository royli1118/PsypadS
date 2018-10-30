//
//  ManageUserTableViewController.swift
//  PsyPad
//
//  Created by Roy Li on 18/08/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation

class ManageUserTableViewController: UITableViewController {
    
    var user : User = User()
    
    @IBOutlet weak var userIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDTextField.text = user.id
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewLogs") {
            let dest = segue.destination as? TestLogTableViewController
            dest?.user = user
        }
    }
    
}
