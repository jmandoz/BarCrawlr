//
//  SignUpViewController.swift
//  BarCrawlr
//
//  Created by Jason Mandozzi on 7/25/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class SignUpViewController: UIViewController {
    

    @IBOutlet weak var activityWheel: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var proPicImageView: UIImageView!
    @IBOutlet weak var usernameTextField: BarCrawlTextField!
    @IBOutlet weak var emailTextField: BarCrawlTextField!
    @IBOutlet weak var confirmButton: BarCrawlButton!
    @IBOutlet weak var emptyFieldsLabel: UILabel!
    @IBOutlet weak var backdropView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        hideKeyboardWhenTappedAround()
        checkForiCloudUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserController.shared.fetchUser { (success) in
            if success {
                DispatchQueue.main.async {
                    self.presentHomeView()
                }
            }
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        if let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let proPic = proPicImageView.image {
            UIView.animate(withDuration: 0.5) {
                self.loadingView.alpha = 1
                self.activityWheel.startAnimating()
                self.diasbleBackgroundView()
            }
            UserController.shared.createUserWith(userName: username, email: email, proPic: proPic) { (user) in
                if user != nil {
                    self.presentHomeView()
                }
            }
        } else {
            self.emptyFieldsLabel.alpha = 1
            UIView.animate(withDuration: 5) {
                self.emptyFieldsLabel.alpha = 0
            }
        }
    }
    
    func presentHomeView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            self.present(viewController, animated: true)
        }
    }
    
    func presentNoiCloudView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "UserSignUp", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NoIcloudView")
            self.present(viewController, animated: true)
        }
    }
    
    func diasbleBackgroundView() {
        confirmButton.isEnabled = false
        usernameTextField.isEnabled = false
        emailTextField.isEnabled = false
        cameraButton.isEnabled = false
    }
    
    func checkForiCloudUser() {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                switch status {
                case .available : print("available")
                case .restricted : print("restricted")
                case .noAccount : self.presentNoiCloudView()
                case .couldNotDetermine : print("Account could not be determined")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}

extension SignUpViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateBarCrawlViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SignUpViewController {
    func setUpUI() {
        let greyBorder = #colorLiteral(red: 0.1137254902, green: 0.137254902, blue: 0.1568627451, alpha: 1).cgColor
        self.view.backgroundColor = UIColor.mainBackground
        loadingView.alpha = 0
        proPicImageView.layer.cornerRadius = 75
        proPicImageView.clipsToBounds = true
        proPicImageView.layer.borderColor = greyBorder
        proPicImageView.layer.borderWidth = 3
        proPicImageView.contentMode = .scaleAspectFill
        backdropView.alpha = 0.4
        emptyFieldsLabel.alpha = 0
        loadingView.backgroundColor = .mainBackground
        loadingView.addBorder(width: 3, color: .lightBlue)
        
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePickerActionSheet(){
        //creating an instance of UIImagePickerController initialized
        let imagePickerController = UIImagePickerController()
        //setting the ImagePickerController delegate
        imagePickerController.delegate = self
        //creating the action sheet that let's the user select either select a photo or use the camera
        let actionSheet = UIAlertController(title: "Select a photo or take a picture", message: nil, preferredStyle: .actionSheet)
        //MARK: - Select a photo from the Library
        //Here we check if the photoLibrary is available as a source type
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //if it is available, we add an action to the action sheet titled "Photo" and if it is selected, than the code below will run
            actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (_) in
                //we set our instance of imagePickerController and set it equal the source type we want: in this case photoLibrary
                imagePickerController.sourceType = .photoLibrary
                //we present imagePicker Controller
                self.present(imagePickerController, animated: true, completion:  nil)
            }))
        }
        //MARK: - Select your camera
        //Here we check if the camera source type is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //same as above, we are adding an action called "Camera"
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            proPicImageView.image = photo
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
