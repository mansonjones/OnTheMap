//
//  InformationPostingView.swift
//  OnTheMap
//
//  Created by Manson Jones on 2/29/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class InformationPostingVC: UIViewController,
    UINavigationControllerDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelInformationEditor() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
