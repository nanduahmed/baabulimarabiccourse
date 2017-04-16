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

typealias AQDictionary = [String:Any?]

class Course {
    var courseID:String?
    var courseName:String?
    var courseDesc:String?
    
     init(dictionary:[String:Any]) {
        self.courseID = dictionary["name"] as! String?
        self.courseName = dictionary["description"] as! String?
    }
}

class Group {
    var courses:[Course]?
    var courseIDs:[String]?
    
    var gpName:String?
    var success = false
    
    required init(params:AQDictionary?) {
        if let values = params {
            self.success = true
            self.courses = [Course]()
            self.courseIDs = [String]()
            for (key, value) in values {
                if (value as? Bool == true) {
                    courseIDs?.append(key)
                }
            }
        }
    }
}

class AllModel {
    static let shared = AllModel()
    var ref: FIRDatabaseReference!
    var currentUser:FIRUser?
    var groupOfCurrentUser:String?
    var currentUserGroup:Group?
    var allCourses:[Course]?
    
    
    func getCourses(forUser:FIRUser, completion: @escaping (([Course]?) -> ()) )  {
        var coursesArray = [Course]()
        self.ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let groups = value?["groups"] as? String ?? ""
            self.groupOfCurrentUser = groups
            self.getCoursesforGroup(group: groups, completion: { (coursesOfThisUser) in
                let group = Group(params: coursesOfThisUser)
                print(group)
                self.currentUserGroup = group
                
                self.getAllCourses(completion: { (courses) in
                    if let userGroupsIds = self.currentUserGroup?.courseIDs {
                        for courseIds in userGroupsIds {
                            for values in courses! {
                                let aCourse = Course(dictionary: values.value as! AQDictionary)
                                aCourse.courseID = values.key
                                if (courseIds ==  aCourse.courseID) {
                                    coursesArray.append(aCourse)
                                    self.currentUserGroup?.courses?.append(aCourse)
                                }
                            }
                        }
                        
                        completion(coursesArray)
                    } else {
                        completion(nil)
                    }
                })
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCoursesforGroup(group:String , completion: @escaping ((_ values:[String:Any]?) -> ())) {
        self.ref = FIRDatabase.database().reference()
        ref.child("class-group").child(group).child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? AQDictionary
            completion(value)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getAllCourses(completion: @escaping ((_ values:AQDictionary?) -> ())) {
        self.ref = FIRDatabase.database().reference()
        ref.child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? AQDictionary
            completion(value)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
