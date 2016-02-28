//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import MapKit

class StudentInformation : NSObject, MKAnnotation {
    // MARK: Properties
    
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let udacityId: String
    let latitude: Double
    let longitude: Double
    let mediaURL: String
    let uniqueKey: Int64
    let mapString: String
    let coordinate: CLLocationCoordinate2D
    
    
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
        latitude = 1.0
        longitude = 1.0
        mediaURL = "https://www.udacity.com"
        mapString = "mapString"
        uniqueKey = 12345
        self.coordinate = CLLocationCoordinate2D(latitude: 100.0, longitude: 100.0)
    }

    init(latitude: Double, longitude: Double) {
        email = "a"
        password = "b"
        firstName = "Keith"
        lastName = "Richards"
        // email = "manson.jones@gmail.com"
        // password = "susie#1"
        udacityId = "blah"
        self.latitude = latitude
        self.longitude = longitude
        mediaURL = "https://www.udacity.com"
        mapString = "mapString"
        uniqueKey = 12345
        print("\(latitude)")
        print("\(longitude)")
        
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /*
    static func studensFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        // iterate through array of dictionaries
        for student in students {
            student.append(StudentInformation(dictionary: result))
        }
        return students
    }
    */
}

// MARK: - StudentInformation: Equatable

/*

extension StudentInformation: Equatable {}

func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
   return lhs.id == rhs.id
}

*/
