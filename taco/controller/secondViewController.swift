//
//  secondViewController.swift
//  taco
//
//  Created by hafied Khalifatul ash.shiddiqi on 07/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit


class secondViewController: UIViewController {


    @IBOutlet weak var start: UIButton!
    
    var isActive:Bool = true
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        start.layer.cornerRadius = 10
    
        
        
    }
   
    @IBAction func start(_ sender: UIButton){
        
        if isActive{
            isActive = false
            start.setTitle("STOP", for: .normal)
        }else{
            self.performSegue(withIdentifier: "stop", sender: self)
        }
        
    }
   

}
