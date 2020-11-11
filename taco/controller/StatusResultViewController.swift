//
//  StatusResultViewController.swift
//  taco
//
//  Created by Franky Chainoor Johari on 10/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit

class StatusResultViewController: UIViewController {
    
    var timer = Timer()
    let url = URL(string: "http://api.likeholidaybatam.com/check_json_status.php")!
    var room_code = UserDefaults.standard.string(forKey: "room_code")!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        isLoading.startAnimating()
        isLoading.isHidden = false
        statusLabel.text = "Please waiting for your result"
        resultButton.isHidden = true
        print(room_code)
        scheduledTimerWithTimeInterval()
    }
    
    // MARK: Timer Loops Function
    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(requestAPIStatus), userInfo: nil, repeats: true)
    }
    
    // MARK: Request API Status
    @objc func requestAPIStatus(){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let stringPost = "room_code=\(room_code)".data(using: .utf8)
        request.httpBody = stringPost

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
//            let dataString = String(data: data!, encoding: .utf8)
//            print(dataString)
            guard let data = data else {return}
            do{
                let statusResult = try JSONDecoder().decode(StatusResponseJson.self, from: data)
            
                DispatchQueue.main.async {
                    if statusResult.status == true{
                        print(statusResult.description)
                        self.timer.invalidate()
                        self.isLoading.stopAnimating()
                        self.isLoading.isHidden = true
                        self.resultButton.isHidden = false
                        self.statusLabel.text = "Your Result is Ready"
                        self.performSegue(withIdentifier: "getResult", sender: nil)
                    }else{
                        print(statusResult.description)
                       
                    }
                }
            }catch let err{
                print("Error", err)
            }
            
        }.resume()
    }
    
    // MARK: Result Button Tapped
    
    @IBAction func resultBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "getResult", sender: nil)
    }
    

}
