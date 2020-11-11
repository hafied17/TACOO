//
//  NameViewController.swift
//  taco
//
//  Created by Franky Chainoor Johari on 11/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    let defaults = UserDefaults.standard

    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(coderoom())
        
    }
    
    func coderoom() -> String {
        return self.defaults.string(forKey: "room_code")!
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        if(nameTextField.text?.isEmpty == true){
            let alert = UIAlertController(title: "Empty Field!", message: "Please fill your name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                //action
            }))
            self.present(alert, animated: true)
        }else{
            performSegue(withIdentifier: "join", sender: nil)
        }
    }
    
}
