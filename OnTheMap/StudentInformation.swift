//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

struct StudentInformation {
    // MARK: Properties
    
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let udacityId: String
    
    // Mark Initializers
    
    // construct a StudentInformation object from
    init(dictionary: [String:AnyObject]) {
        email = dictionary[UdacityClient.JSONBodyKeys.Username] as! String
        password = dictionary[UdacityClient.JSONBodyKeys.Password] as! String
        firstName = "Keith"
        lastName = "Richards"
        // email = "manson.jones@gmail.com"
        // password = "susie#1"
        udacityId = "blah"
    }
}
