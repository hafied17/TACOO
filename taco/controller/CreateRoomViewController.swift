//
//  CreateRoomViewController.swift
//  taco
//
//  Created by Franky Chainoor Johari on 12/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController {

    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var meetingCode: UILabel!
    var Active:Bool = true
    // test commit
    override func viewDidLoad() {
        super.viewDidLoad()
        create.layer.cornerRadius = 10.0
     
    }
    
     @IBAction func create(_ sender: UIButton){
        
        if Active{
            Active = false
            create.setTitle("Next", for: .normal)
            fetchAPI()
        }else{
            alertMemberName()
        }
        
        
        
    }
    
    func fetchAPI() {
        guard let gitURL = URL(string: "http://api.likeholidaybatam.com/generate_room_code.php") else {return}
            
        _ =  ["host_id": GenerateUUID()]
            var request = URLRequest(url: gitURL)
            request.httpMethod = "POST"
            
        
            let stringPost="host_id=\(memberID())" // Key and Value 
            let data = stringPost.data(using: .utf8)
            request.timeoutInterval = 60
            request.httpBody=data
            
        
            URLSession.shared.dataTask(with: request) { (data, respone, error) in
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let roomData = try decoder.decode(CreateRoom.self, from: data)
                   
                    print(roomData.room_code!)
                    DispatchQueue.main.async {
                        
                        self.meetingCode.text = "\(String(describing: roomData.room_code!))"
                        defaults.set(roomData.room_code!, forKey: "room_code")
                        defaults.set(true, forKey: "isHost")
                    }
                    
                    
                   
                }catch let err{
                    print("Error", err)
                }
            }.resume()
    }
    
    func alertMemberName() {
        let alert = UIAlertController(title: "Your Name", message: "Please input your name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "Name"
        }
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (UIAlertAction) in
                self.performSegue(withIdentifier: "create", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    

    

}
