//
//  CreateSnapViewController.swift
//  Snapfun
//
//  Created by Nahid on 2/7/19.
//  Copyright © 2019 Nahid. All rights reserved.
//

import UIKit
import FirebaseStorage

class CreateSnapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imageName = "\(NSUUID().uuidString).jpeg"
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        let imageFolder = Storage.storage().reference().child("images")
        if let image = imageView.image {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                imageFolder.child(imageName).putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print(error)
                    } else {
                        imageFolder.child(self.imageName).downloadURL(completion: { (url, error) in
                            if let imageURL = url?.absoluteString {
                                self.imageURL = imageURL
                                self.performSegue(withIdentifier: "moveToSender", sender: nil)
                            }
                        })
                    }
                }
            }
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectVC = segue.destination as? SelectUserTableViewController {
            selectVC.imageName = imageName
            selectVC.imageURL = imageURL
            if let message = noteTextField.text {
                selectVC.message = message
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
