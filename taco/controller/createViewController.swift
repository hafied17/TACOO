//
//  createViewController.swift
//  taco
//
//  Created by hafied Khalifatul ash.shiddiqi on 07/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class createViewController: UIViewController {

    @IBOutlet weak var create: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        create.layer.cornerRadius = 10.0
    }
    
     @IBAction func create(_ sender: UIButton){
           
           
               self.performSegue(withIdentifier: "create", sender: self)
           
           
       }

}
