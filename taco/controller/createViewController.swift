//
//  createViewController.swift
//  taco
//
//  Created by hafied Khalifatul ash.shiddiqi on 07/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var meetingCode: UILabel!
    var Active:Bool = true
    let defaults = UserDefaults.standard
    
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
            self.performSegue(withIdentifier: "create", sender: self)
        }
        
        
        
    }
    
    func fetchAPI() {
        guard let gitURL = URL(string: "http://api.likeholidaybatam.com/generate_room_code.php") else {return}
            
        _ =  ["host_id": UUID().uuidString]
            var request = URLRequest(url: gitURL)
            request.httpMethod = "POST"
            
        
            let stringPost="host_id=\(UUID().uuidString)" // Key and Value 
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
                        self.defaults.set(roomData.room_code, forKey: "room_code")
                    }
                    
                    
                   
                }catch let err{
                    print("Error", err)
                }
            }.resume()
    }
    
    struct CreateRoom: Codable {
        let status: Bool?
        let description: String?
        let room_code: Int?
        
        private enum CodingKeys: String, CodingKey{
            case status
            case description
            case room_code
        }
    }

}
