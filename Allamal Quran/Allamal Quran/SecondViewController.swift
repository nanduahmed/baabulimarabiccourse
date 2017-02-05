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

  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let email:String? = "nanduahmed.testing@gmail.com", let password:String? = "Sikka123" else { return }
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            //self.signedIn(user!)
        }
    }


}

