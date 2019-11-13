//
//  ViewController.swift
//  NiceCameraDemo
//
//  Created by Informatica Labo Mac on 12/11/19.
//  Copyright © 2019 Dan Beltrami. All rights reserved.
//

import UIKit
import NiceCamera

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NiceCamera.openVC(caller: self)
        NiceCamera.performSegueToFrameworkVC(caller: self)
    }
}

