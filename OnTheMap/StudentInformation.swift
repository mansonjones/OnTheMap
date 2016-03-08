//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/18/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import MapKit

struct StudentInformation {
    // MARK: Properties
    
    var firstName: String
    var lastName: String
    // let udacityId: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String  /* The Udacity account (user) id */
    
    let coordinate: CLLocationCoordinate2D
    
    
    // Mark Initializers
    init() {
        firstName = ""
        lastName = ""
        latitude = 1.0
        longitude = 2.0
        mapString = ""
        mediaURL = ""
        uniqueKey = ""
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // construct a StudentInformation object from
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaUrl] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        // uniqueKey = "u12345"
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        // coordinate could also be defined as a computed parameter.
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // One of the requirements is that the array of students should be stored
    // outside the tableviewcontroller and the mapviewcontroller.
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        // iterate through array of dictionaries
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        return students
    }
    
}

// MARK: - StudentInformation: Equatable

/*

extension StudentInformation: Equatable {}

func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
return lhs.id == rhs.id
}

*/
