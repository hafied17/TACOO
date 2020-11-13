//
//  firstViewController.swift
//  taco
//
//  Created by hafied Khalifatul ash.shiddiqi on 07/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var global:Bool?
    @IBOutlet var field: UITextField!
    @IBOutlet weak var join: UIButton!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var textField: UITextField!
    let defaults = UserDefaults.standard
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
        let stringPost="member_id=\(GenerateUUID())&room_code=\(meetingCode)" // Key and Value 
        let data = stringPost.data(using: .utf8)
            request.httpBody=data
          
    URLSession.shared.dataTask(with: request) { (data, respone, error) in
        
    guard let data = data else { return }
        do {
            let decoder = JSONDecoder()
            let roomData = try decoder.decode(JoinRoom.self, from: data)
        
            print(roomData.status!)
            DispatchQueue.main.async {
                print(self.memberID())
                if roomData.status == true{
                    self.defaults.set(meetingCode, forKey: "room_code")
                    self.alertMemberName()
                }else{
                    let alert = UIAlertController(title: "Room doesn't exist!", message: "Please check your room code again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        //action
                    }))
                    self.present(alert, animated: true)
                }
            }
            
            }catch let err{
                 print("Error", err)
            }
        }.resume()
    }
    
    func NamaAPI(namaUser: String) {
        guard let girURL = URL(string: "http://api.likeholidaybatam.com/insert_nama.php") else {return}
        var request = URLRequest(url:girURL)
            request.httpMethod = "POST"
        
        
        let stringPost="member_id=\(memberID())&nama=\(namaUser)"
        let data = stringPost.data(using: .utf8)
        request.httpBody=data
        
        URLSession.shared.dataTask(with: request) { (data, respone, error) in
            
            guard let data = data else {return}
            do{
                let decoder = JSONDecoder()
                let roomData = try decoder.decode(NamaUser.self, from: data)
                
                print(roomData.nama!)
                
                
            }catch let err{
                print("Error", err)
            }
        }.resume()
        
    }
    
    func GenerateUUID() -> String{
        let uuid = UUID().uuidString
        defaults.set(uuid, forKey: "UUID")
        return uuid
    }
    
    func memberID() -> String {
        let uuid = defaults.string(forKey: "UUID")!
        return uuid
    }
    
    func alertMemberName() {
        let alert = UIAlertController(title: "Your Name", message: "Please input your name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (UIAlertAction) in
            if(self.textField.text?.isEmpty == false){
                self.defaults.set(false, forKey: "isHost")
                
                guard let textFieldNama =  alert.textFields?.first?.text else{return}
                self.defaults.set(false, forKey: "isHost")
                self.NamaAPI(namaUser: textFieldNama)
                self.performSegue(withIdentifier: "join", sender: self)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    
    struct JoinRoom: Codable {
        let status: Bool?
        let description: String?

    
    private enum CodingKeys: String, CodingKey{
        case status
        case description
     }
    }
    struct NamaUser: Codable {
        let status: Bool?
        let description: String?
        let nama: String?

    
    private enum CodingKeys: String, CodingKey{
        case status
        case description
        case nama
     }
    }
    
    
}

    

