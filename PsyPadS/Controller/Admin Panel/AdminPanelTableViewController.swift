//
//  AdminPanelTableViewController.swift
//  PsyPad
//
//  Created by Roy Li on 29/09/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation



class AdminPanelTableViewController : UITableViewController {
    
    var users: [User] = []
    var serverUsers: [User] = []
    var hud: MBProgressHUD?
    // Some enum constants, However enum cannot have the values
    let sLocalUsers : Int = 0
    let sServerUsers : Int = 1
    let sUploadDownload : Int = 2
    let rUploadLogs : Int = 0
    let rDownloadAll : Int = 1
    let sAdmin : Int = 3
    let rDemoMode : Int = 0
    let rAdminPassword : Int = 1
    let rLogout : Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = User.mr_findAll() as! [User]
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sLocalUsers {
            return max(1, users.count)
        } else if section == sServerUsers {
            return serverUsers.count + 1
        } else if section == sUploadDownload {
            return 2
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        var cell : UITableViewCell?
        if indexPath.section == sLocalUsers {
            if self.users.count == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "NoParticipantsCell", for: indexPath)
            }
            
            var tvCell : UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
            var user : User = users[Int(indexPath.row)] as! User
            tvCell.textLabel.text = user.id
            //tvCell.detailTextLabel.text = String(format: "%lu test, %lu practice, %lu logs", UInt(user.configurations!.count), UInt(user.practiceConfigurations().count), UInt(user.logs!.count))
            tvCell.downloadAction = {
                weakSelf?.downloadParticipant(username: user.id)
            }
            cell = tvCell
        }
        else if indexPath.section == sServerUsers && indexPath.row < self.serverUsers.count {
            var tvCell : UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ServerUserCell") as! UserTableViewCell
            var user = serverUsers[indexPath.row]
//            tvCell.textLabel.text = user
//
//            tvCell.detailTextLabel.text = user["desc"]
//            tvCell.downloadAction = {
//                weakSelf?.downloadParticipant(username: user["username"])
//            }
            cell = tvCell
        }
        else if indexPath.section == sServerUsers {
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadUserListCell")
        }
        else if indexPath.section == sUploadDownload {
            if indexPath.row == rUploadLogs {
                cell = tableView.dequeueReusableCell(withIdentifier: "UploadLogsCell")
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "DownloadAllCell")
            }
        }
        else if indexPath.section == sAdmin {
            if indexPath.row == rDemoMode {
                var theCell : SwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DemoModeCell") as! SwitchTableViewCell
                var rootEntity : RootEntity?
                theCell.theSwitch.isOn = (rootEntity?.demoModeValue)!
                cell = theCell
            }
            else if indexPath.row == rAdminPassword{
                var theCell : TextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminPasswordCell") as! TextFieldTableViewCell
                var rootEntity : RootEntity?
                theCell.textField.text = rootEntity?.admin_password
                cell = theCell
            }
            else // if (indexPath.row == rLogout)
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell")
            }
        }
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sLocalUsers && indexPath.row == self.users.count {
            return 44
        }
        else if indexPath.section == sServerUsers && indexPath.row == self.serverUsers.count {
            return 44
        }
        else if indexPath.section == sUploadDownload || indexPath.section == sAdmin {
            return 44
        }
        else{
            return 64
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == sServerUsers && indexPath.row == self.serverUsers.count {
            self.loadServerParticipants()
        }
        else if indexPath.section == sUploadDownload{
            if indexPath.row == rUploadLogs {
                self.uploadLogs()
            }
            else // if (indexPath.row == rDownloadAll)
            {
                self.downloadAllParticipants()
            }
        }
        else if indexPath.section == sAdmin && indexPath.row == rLogout {
            self.logout()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func createHUD() -> MBProgressHUD? {
        let window: UIWindow? = view.window
        let hud = MBProgressHUD.showAdded(to: window!, animated: true)
        return hud
    }
    
    func loadServerParticipants() {
        hud = createHUD()
        hud?.mode = MBProgressHUDMode.indeterminate
        hud?.labelText = "Loading users..."
        ServerManager.shared().loadServerParticipants({ participants in
            self.serverUsers = participants as! [User]
            self.tableView.reloadSections(NSIndexSet(index: self.sServerUsers) as IndexSet, with: .automatic)
            self.hud?.hide(true)
            self.hud?.removeFromSuperview()
        }, failure: { error in
            self.hud?.hide(true)
            self.hud?.removeFromSuperview()
            let alert = UIAlertController(title: "Failed to Load Participants", message: error!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
        })
        return
    }
    func downloadParticipant(username: String) {
        hud = createHUD()
        hud?.mode = MBProgressHUDMode.indeterminate
        hud?.label.text = "Downloading participant..."
        ServerManager.shared().downloadAllParticipants({ status, progress in
            self.hud?.label.text = status!
            self.hud?.progress = progress
        }, success: { newUser in
            if let anUser = newUser as? User {
                if !self.users.contains(anUser) {
                    self.users.append(anUser)
                }
            }
            let alert = UIAlertController(title: "User downloaded successfully.", message: "User downloaded successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.tableView.reloadData()
            self.hud?.hide(animated: true)
            self.hud?.removeFromSuperview()
        }, failure: { error in
            self.hud?.hide(animated: true)
            self.hud?.removeFromSuperview()
            let alert = UIAlertController(title: "Failed to Download Participant", message: error!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
        })
    }
    
    func uploadLogs() {
        hud = createHUD()
        hud?.mode = MBProgressHUDMode.indeterminate
        hud?.label.text = "Uploading..."
        ServerManager.shared().uploadLogs(progress: { status, progress in
            self.hud?.label.text = status!
            self.hud?.progress = progress
        }, success: {
            self.hud?.hide(animated: true)
            self.hud?.removeFromSuperview()
            let alert = UIAlertController(title: "Logs successfully uploaded", message: "Logs successfully uploaded", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
        }, failure: { error in
            self.hud?.hide(animated: true)
            self.hud?.removeFromSuperview()
            let alert = UIAlertController(title: "Failed to Upload Logs", message: error!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
        })
    }
    
    func downloadAllParticipants() {
        hud = createHUD()
        hud?.mode = MBProgressHUDMode.indeterminate
        hud?.label.text = "Downloading participants..."
        ServerManager.shared().downloadAllParticipants({ status, progress in
            self.hud?.label.text = status!
            self.hud?.progress = progress
        }, success: { newUsers in
//            for user: User? in newUsers ?? [] {
//                if let anUser = user {
//                    if !self.users.contains(anUser) {
//                        self.users.append(anUser)
//                    }
//                }
//            }
            self.hud?.hide(animated: true)
            self.hud?.removeFromSuperview()
            (UIAlertView(title: "", message: String(format: "%lu participants downloaded", UInt(newUsers?.count ?? 0)), delegate: nil, cancelButtonTitle: "Close", otherButtonTitles: "")).show()
        }, failure: { error in
            self.hud?.hide(animated: true)
            self.hud?.removeFromSuperview()
            UIAlertView(title: "Failed to Upload Logs", message: error!, delegate: nil, cancelButtonTitle: "Close", otherButtonTitles: "").show()
        })
    }
    
    func logout() {
        weak var weakSelf = self
        let logOut : RIButtonItem = RIButtonItem.item(withLabel: "Log Out") as! RIButtonItem
        logOut.action = {
            ServerManager.shared().logout()
            let nav = weakSelf?.navigationController?.presentingViewController as? UINavigationController
            nav?.setViewControllers([LoginViewController.loadFromMainStoryboard(), (nav?.topViewController)!], animated: false)
            weakSelf?.navigationController?.dismiss(animated: true) {
                nav?.popViewController(animated: true)
            }
        }
        let alert = UIAlertController(title: "Are you sure you want to\nlog out of PsyPad?", message: "Are you sure you want to\nlog out of PsyPad?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            NSLog("The \"Cancel\" alert occured.")
        }))
    }
    
}
extension AdminPanelTableViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Miss the Alert View functions
        return false
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row < self.users.count {
            return true
        }
        else{
            return false
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            var selectedUser : User = self.users[indexPath.row]

            users.removeAll(where: { element in element == selectedUser })
            selectedUser.mr_deleteEntity()
            DatabaseManager.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }

    @IBAction func saveChanges(_ sender: Any) {
        RootEntity().admin_password = (sender as? UITextField)?.text
        DatabaseManager.save()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ManageUser") {
            let dest = segue.destination as? ManageUserTableViewController
            let selectedUser = users[Int(tableView.indexPathForSelectedRow?.row ?? 0)]
            dest?.title = selectedUser.id
            dest?.user = selectedUser
        }
    }

    @IBAction func dismissModal(_ sender: Any) {
        let presenting: UIViewController? = (presentingViewController as? UINavigationController)?.topViewController
        dismiss(animated: true) {
            if (presenting is DemoViewController) && !RootEntity().demoModeValue {
                let nav: UINavigationController? = presenting?.navigationController
                var vcs = nav?.viewControllers
                vcs?.removeLast()
                vcs?.append(MainMenuViewController.loadFromMainStoryboard())
                if let aVcs = vcs {
                    nav?.setViewControllers(aVcs, animated: true)
                }
            } else if (presenting is MainMenuViewController) && RootEntity().demoModeValue {
                let nav: UINavigationController? = presenting?.navigationController
                var vcs = nav?.viewControllers
                vcs?.removeLast()
                vcs?.append(DemoViewController.loadFromMainStoryboard())
                if let aVcs = vcs {
                    nav?.setViewControllers(aVcs, animated: true)
                }
            }
        }
    }
    
    @IBAction func demoModeToggled(_ sender: UISwitch) {
        RootEntity().demoModeValue = sender.isOn
        if !sender.isOn {
            var message: String
            let rootEntity = RootEntity()
            if rootEntity.admin_password?.count == 0 {
                message = "No admin password has been set. If you want to restrict access to the admin panel, please set an admin password. Login as \"admin\" to open the admin panel."
            } else {
                message = "Make sure you know the admin password (or set a new one) so you can return to the admin panel. Login as \"admin\" to open the admin panel."
            }
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .cancel, handler: { _ in
                NSLog("The \"Cancel\" alert occured.")
            }))
        }
        DatabaseManager.save()
    }
    
}
