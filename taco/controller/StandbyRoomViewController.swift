//
//  StandbyRoomViewController.swift
//  taco
//
//  Created by Franky Chainoor Johari on 11/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class StandbyRoomViewController: UIViewController {

    @IBOutlet weak var roomCode: UILabel!
    @IBOutlet weak var statusMetting : UILabel!
    
    var finalRoomCode:String = ""
    let defaults = UserDefaults.standard
    var timer = Timer()
       
      
       override func viewDidLoad() {
           super.viewDidLoad()

            roomCode.text = "Room Code \(room_code())"
            scheduledTimerWithTimeInterval()
        // Tadi salah dsini
       }
    
        func scheduledTimerWithTimeInterval() {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkStatusAPI), userInfo: nil, repeats: true)
        }
       
    @objc func checkStatusAPI(){
       guard let gitURL = URL(string: "http://api.likeholidaybatam.com/check_status_meeting.php") else {return}
       
       var request = URLRequest(url: gitURL)
           request.httpMethod = "POST"
           
       
           let stringPost="room_code=\(room_code())" // Key and Value 
        
            print(stringPost)
           let data = stringPost.data(using: .utf8)
               request.httpBody=data
             
       URLSession.shared.dataTask(with: request) { (data, respone, error) in
           
       guard let data = data else { return }
           do {
                let decoder = JSONDecoder()
            let roomData = try decoder.decode(CheckStatus.self, from: data)
           
            print(roomData.status!)
            DispatchQueue.main.async {
                
                if roomData.status! == false{
                    self.statusMetting.text="Wait for the Host to start the meeting"
                }else{
                    self.statusMetting.text="Ready"
                    
                }
            }
                     
               
               }catch let err{
                    print("Error", err)
               }
           }.resume()
       }
    func memberID() -> String {
          let uuid = defaults.string(forKey: "UUID")!
          return uuid
      }
    func room_code() -> String {
          return self.defaults.string(forKey: "room_code")!
      }
    
    
    struct CheckStatusq: Codable {
        var status: Bool?
          let description: String?

      
      private enum CodingKeys: String, CodingKey{
          case status
          case description
       }
    }

}
