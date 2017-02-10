//
//  FirstViewController.swift
//  Allamal Quran
//
//  Created by Nandu Ahmed on 2/5/17.
//  Copyright © 2017 Baabul Ilm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirstViewController: UIViewController {
    
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
            AllModel.shared.getCourses(forUser: (FIRAuth.auth()?.currentUser)!, completion: { (courses) in
                print(courses ?? "")
            })
        }
    }
    
    func signedIn(_ user: FIRUser?) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

