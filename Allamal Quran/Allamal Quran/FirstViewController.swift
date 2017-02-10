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

    @IBOutlet weak var tableView: UITableView!
    var coursesData = [Course]()
    
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
                self.coursesData = courses!
                self.tableView.reloadData()
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

extension FirstViewController : UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coursesData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")
        cell?.textLabel?.text = self.coursesData[indexPath.row].courseName
        cell?.detailTextLabel?.text = self.coursesData[indexPath.row].courseDesc
        
        return cell!
    }
}

