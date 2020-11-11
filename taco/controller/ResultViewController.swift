//
//  ResultViewController.swift
//  taco
//
//  Created by Franky Chainoor Johari on 11/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLabal: UILabel!
    
    let url = URL(string: "http://api.likeholidaybatam.com/get_interuptions_result.php")!
    var room_code = UserDefaults.standard.string(forKey: "room_code")!
    var member_id = UserDefaults.standard.string(forKey: "UUID")!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAPIResult()
        // Do any additional setup after loading the view.
    }
    
    func requestAPIResult(){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let stringPost = "room_code=\(room_code)&member_id=\(member_id)".data(using: .utf8)
        request.httpBody = stringPost

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            let dataString = String(data: data!, encoding: .utf8)
            print(dataString)
            guard let data = data else {return}
            do{
                let statusResult = try JSONDecoder().decode(Result.self, from: data)
            
                DispatchQueue.main.async {
                    print(statusResult.total_terinterruptions)
                }
            }catch let err{
                print("Error", err)
            }
            
        }.resume()
    }

}
