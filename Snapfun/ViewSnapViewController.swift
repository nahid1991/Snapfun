//
//  ViewSnapViewController.swift
//  Snapfun
//
//  Created by Nahid on 3/7/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class ViewSnapViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var snapshot : DataSnapshot?
    var imageName = ""
    var snapID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapshot = snapshot {
            if let snapDictionary = snapshot.value as? NSDictionary {
                if let imageName = snapDictionary["imageName"] as? String {
                    if let imageURL = snapDictionary["imageURL"] as? String {
                        if let message = snapDictionary["message"] as? String {
                            messageLabel.text = message
                            if let url = URL(string: imageURL) {
                                imageView.sd_setImage(with: url, completed: nil)
                            }
                            self.imageName = imageName
                            snapID = snapshot.key
                        }
                    }
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).child("snaps").child(snapID).removeValue()
            
            Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
        }
    }
}
