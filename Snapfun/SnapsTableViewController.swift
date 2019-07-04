//
//  SnapsTableViewController.swift
//  Snapfun
//
//  Created by Nahid on 2/7/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsTableViewController: UITableViewController {
    
    var snaps : [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).child("snaps").observe(.childAdded) { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                Database.database().reference().child("users").child(uid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    var index = 0
                    for snap in self.snaps {
                        if snapshot.key == snap.key {
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return snaps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let snap = snaps[indexPath.row]
        
        if let snapDictionary = snap.value as? NSDictionary {
            if let from = snapDictionary["from"] as? String {
                cell.textLabel?.text = from
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnap", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewVC = segue.destination as? ViewSnapViewController {
            if let snap = sender as? DataSnapshot {
                viewVC.snapshot = snap
            }
        }
    }
}
