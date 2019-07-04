//
//  SelectUserTableViewController.swift
//  Snapfun
//
//  Created by Nahid on 3/7/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectUserTableViewController: UITableViewController {
    
    var imageName = ""
    var imageURL = ""
    var message = ""
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let userDictionary = snapshot.value as? NSDictionary {
                if let email = userDictionary["email"] as? String {
                    let user = User()
                    user.email = email
                    user.uid = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let fromEmail = Auth.auth().currentUser?.email {
            let snapDictionary = ["from": fromEmail, "imageName": imageName, "imageURL": imageURL, "message": message]
            
            Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snapDictionary)
            
            navigationController?.popToRootViewController(animated: true)
            
        }
    }
}

class User {
    var email = ""
    var uid = ""
}
