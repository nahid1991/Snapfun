//
//  AuthViewController.swift
//  Snapfun
//
//  Created by Nahid on 1/7/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var loginMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if loginMode {
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error == nil {
                            self.performSegue(withIdentifier: "authSuccess", sender: nil)
                        }
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password) {
                        (result, error)
                        in
                        if error == nil {
                            if let uid = result?.user.uid {
                                Database.database().reference().child("users").child(uid).child("email").setValue(email)
                                self.performSegue(withIdentifier: "authSuccess", sender: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        if loginMode {
            loginMode = false
            topButton.setTitle("Sign up", for: .normal)
            bottomButton.setTitle("Switch to Login", for: .normal)
        } else {
            loginMode = true
            topButton.setTitle("Login", for: .normal)
            bottomButton.setTitle("Switch to Sign up", for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
