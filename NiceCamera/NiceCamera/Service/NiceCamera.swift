//
//  NiceCamera.swift
//  NiceCamera
//
//  Created by Informatica Labo Mac on 12/11/19.
//  Copyright © 2019 Dan Beltrami. All rights reserved.
//

import UIKit

public class NiceCamera {

    public static func openVC(caller: UIViewController) {
        
        let s = UIStoryboard (
            name: "CameraSB", bundle: Bundle(for: CameraVC.self)
        )
        let vc = s.instantiateInitialViewController()!
        caller.present(vc, animated: true, completion: nil)
    }
    
    public static func performSegueToFrameworkVC(caller: UIViewController) {
           let storyboard = UIStoryboard(name: "CameraSB", bundle: bundle)
           let vc = storyboard.instantiateInitialViewController()!
        caller.present(vc, animated: true, completion: nil)
       }
       
    static var bundle:Bundle {
        let podBundle = Bundle(for: CameraVC.self)
           
        let bundleURL = podBundle.url(forResource: "NiceCamera", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
       }
}
