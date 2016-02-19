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
    
    // Mark Initializers
    
    // construct a StudentInformation object from
    init(dictionary: [String:AnyObject]) {
        firstName = "Keith"
        lastName = "Richards"
    }
}
