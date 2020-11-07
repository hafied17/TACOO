//
//  firstViewController.swift
//  taco
//
//  Created by hafied Khalifatul ash.shiddiqi on 07/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class firstViewController: UIViewController {
    
    @IBOutlet var field: UITextField!
    @IBOutlet weak var join: UIButton!
    @IBOutlet weak var create: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        join.layer.cornerRadius = 10.0
        
        
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.becomeFirstResponder()
       }
    
    }

    
    
    

