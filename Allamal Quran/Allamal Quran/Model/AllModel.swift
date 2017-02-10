//
//  AllModel.swift
//  Allamal Quran
//
//  Created by Nandu Ahmed on 2/5/17.
//  Copyright © 2017 Baabul Ilm. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Course {
    var courseID:String?
    var courseName:String?
    var courseDesc:String?
    
    
    
     init(dictionary:[String:Any]) {
        self.courseID = dictionary["name"] as! String?
        self.courseName = dictionary["description"] as! String?
    }
}

class AllModel {
    static let shared = AllModel()
    var ref: FIRDatabaseReference!
    
    func getCourses(forUser:FIRUser, completion: @escaping (([Course]?) -> ()) )  {
        var coursesArray = [Course]()
        self.ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let groups = value?["groups"] as? String ?? ""
            self.getCoursesforGroup(group: groups, completion: { (some) in
                self.getAllCourses(completion: { (courses) in
                    print(courses ?? "")
                    
                    for values in courses! {
                        //let aCourse = Course(dictionary: key)
                        //let aCourseDict = values as? [String:Any]
                        let aCourse = Course(dictionary: values.value as! [String : Any])
                        aCourse.courseID = values.key
                        coursesArray.append(aCourse)
                    }
                    
                    
                })
            })
            completion(nil)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCoursesforGroup(group:String , completion: @escaping ((_ values:[String:Any]?) -> ())) {
        self.ref = FIRDatabase.database().reference()
        ref.child("class-group").child(group).child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String:Any]
            completion(value)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getAllCourses(completion: @escaping ((_ values:[String:Any]?) -> ())) {
        self.ref = FIRDatabase.database().reference()
        ref.child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String:Any]
            completion(value)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
