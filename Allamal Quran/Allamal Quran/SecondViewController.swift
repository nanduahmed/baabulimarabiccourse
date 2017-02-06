//
//  SecondViewController.swift
//  Allamal Quran
//
//  Created by Nandu Ahmed on 2/5/17.
//  Copyright © 2017 Baabul Ilm. All rights reserved.
//

import UIKit
import FirebaseAuth

class SecondViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var reEnterPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signinSegmentControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSignInFields(value: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let email = self.emailTextField.text, let password = self.passwordtextField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.statusLabel.text = error.localizedDescription
                return
            }
            self.statusLabel.text = "Logged in as " + (user?.email)!
            self.clearFields()
        }
    }
    
    
    @IBAction func SignUp(_ sender: Any) {
        let anEmail:String! = self.emailTextField.text
        let aPassword:String! = self.passwordtextField.text
        if (self.validatePasswords()) {
            guard let email = anEmail, let password = aPassword else { return }
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.statusLabel.text = error.localizedDescription
                    return
                }
                self.statusLabel.text = "Sign Up Successful !!"
                self.clearFields()
            }
        } else {
            let alertController = UIAlertController(title: "Password Error", message: "Your Passwords are not similar", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            self.clearFields()
        }
    }
    
    func validatePasswords() -> Bool {
        return self.passwordtextField.text == self.reEnterPassword.text
    }
    
    func clearFields() {
        self.emailTextField.text = ""
        self.passwordtextField.text = ""
        self.reEnterPassword.text = ""
    }
    
    
    @IBAction func onSegmentSelection(_ sender: Any) {
        let segmentCont = sender as! UISegmentedControl
        switch segmentCont.selectedSegmentIndex {
        case 0:
            self.showSignInFields(value: true)
            break
        case 1:
            self.showSignInFields(value: false)
            break
        default:
            self.showSignInFields(value: true)
        }
    }
    
    func showSignInFields(value:Bool) {
        if (value == true) {
            self.reEnterPassword.isHidden = true
            self.signUpButton.isHidden = true
            self.signInButton.isHidden = false
        } else {
            self.reEnterPassword.isHidden = false
            self.signUpButton.isHidden = false
            self.signInButton.isHidden = true
        }
    }
}




