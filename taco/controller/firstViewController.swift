//
//  firstViewController.swift
//  taco
//
//  Created by hafied Khalifatul ash.shiddiqi on 07/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class firstViewController: UIViewController {
    
    var global:Bool?
    @IBOutlet var field: UITextField!
    @IBOutlet weak var join: UIButton!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var textField: UITextField!
    var isActive:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        join.layer.cornerRadius = 10.0
        
        
        field.returnKeyType = .done
        field.autocorrectionType = .no
        
       }
    
    
   @IBAction func join(_ sender: Any) {
    
    JoinAPI()
   
    
    
   }
     
    
   func JoinAPI(){
    guard let gitURL = URL(string: "http://api.likeholidaybatam.com/join_meeting_room.php") else {return}
    
    var request = URLRequest(url: gitURL)
        request.httpMethod = "POST"
        
    guard let meetingCode = textField.text else { return }
        let stringPost="member_id=\(UUID().uuidString)&room_code=\(meetingCode)" // Key and Value 
        let data = stringPost.data(using: .utf8)
            request.httpBody=data
          
    URLSession.shared.dataTask(with: request) { (data, respone, error) in
        
    guard let data = data else { return }
        do {
            let decoder = JSONDecoder()
            let roomData = try decoder.decode(JoinRoom.self, from: data)
        
            print(roomData.status!)
            DispatchQueue.main.async {
                if roomData.status == true{
                self.performSegue(withIdentifier: "join", sender: self)
                }
            }
            
            }catch let err{
                 print("Error", err)
            }
        }.resume()
    }
        
    
    struct JoinRoom: Codable {
        let status: Bool?
        let description: String?

    
    private enum CodingKeys: String, CodingKey{
        case status
        case description
     }
    }
    
    
}

    

