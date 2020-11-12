//
//  secondViewController.swift
//  taco
//
//  Created by hafied Khalifatul ash.shiddiqi on 07/11/20.
//  Copyright © 2020 hafied. All rights reserved.
//

import UIKit
import Speech
import Foundation


class StartViewController: UIViewController, SFSpeechRecognizerDelegate {

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    @IBOutlet weak var roomCodeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var meetingRoom = postDataMeeting()
    var fullTranscript = [postDataTranscript]()
    var isHost:Bool = false
    var isStart:Bool = true
    var timer = Timer()

 
    var transcriptionStartTime: TimeInterval = 0
    
    
    
    @IBOutlet weak var start: UIButton!
    
    var isActive:Bool = true

    override func viewDidLoad() {
        print(defaults.string(forKey: "room_code")!)
        print(defaults.string(forKey: "UUID")!)
        isHost = defaults.bool(forKey: "isHost")

        
        super.viewDidLoad()
        start.layer.cornerRadius = 10
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.start.isEnabled = true
                    
                case .denied:
                    self.start.isEnabled = false
                    self.start.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.start.isEnabled = false
                    self.start.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.start.isEnabled = false
                    self.start.setTitle("Speech recognition not yet authorized", for: .disabled)
                    
                default:
                    self.start.isEnabled = false
                }
            }
        }
        
        if(isHost){
            start.isHidden = false
            roomCodeLabel.isHidden = true
            statusLabel.isHidden = true
        }else{
            start.isHidden = false
            roomCodeLabel.isHidden = false
            statusLabel.isHidden = false
            roomCodeLabel.text = "Your room code is \(defaults.string(forKey: "room_code")!)"
            scheduledTimerWithTimeInterval()
        }
    
    }
    
    
    
    
    private func startRecording() throws {
        var room_code = defaults.string(forKey: "room_code")
        
        // Cancel the previuos task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio seesion for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and Configure the speech Recognition Request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest Object")}
        recognitionRequest.shouldReportPartialResults = true

        speechRecognizer.defaultTaskHint = .dictation
        
        // Keep Speech Recognition data on device
        if #available(iOS 13, *){
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [self] result, error in
            var isFinal = false
            var listChat: postDataTranscript!
            
            if let result = result {
                // Update the text view with the results.
//                self.txtlbl.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Text : \(result.bestTranscription.formattedString)")
                
                // Save initial time
                if self.transcriptionStartTime == 0 {
                    self.transcriptionStartTime = Date().timeIntervalSince1970
                }
                if result.isFinal {
                    
                    for segment in result.bestTranscription.segments {
//                        listChat = postDataTranscript(speakerID: "1", text: segment.substring, timestamp: segment.timestamp, duration: segment.duration)
                        listChat = postDataTranscript(speakerID: memberID(), timestampStart: (self.transcriptionStartTime + segment.timestamp), duration: segment.duration, timestampEnd: (self.transcriptionStartTime + segment.timestamp + segment.duration), text: segment.substring)
                        print("Text: \(segment.substring) - Time: \(segment.timestamp) - Duration: \(segment.duration)")
                        self.fullTranscript.append(listChat)
//                        print(Date().timeIntervalSince1970)
                        
                    }
                    
                    self.meetingRoom.fullTranscription = self.fullTranscript


                    // MARK: Encode array to JSON
                    do{
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(self.meetingRoom)
                        let jsonString = String(data: jsonData, encoding: .utf8)
                        print(jsonString!)

                        // MARK: Create JSON File in Local
                        let fileManager = FileManager.default
                        let filepath = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        print("url filepath: \(filepath)")
                        let fileJsonUrl = filepath.appendingPathComponent(self.memberID()).appendingPathExtension("json")
                        print("file path: \(fileJsonUrl)")

                        do{
                            try jsonString?.write(to: fileJsonUrl, atomically: true, encoding: String.Encoding.utf8)
                        }catch let error as NSError{
                            print("Error: fileJsonUrl failed to write: \n\(error)")
                        }

                        // MARK: Request POST Method
                        let boundary = self.generateBoundaryString()
                        let fileJsonData = try Data(contentsOf: fileJsonUrl)
                        let url = URL(string: "http://api.likeholidaybatam.com/upload_meeting_transcript.php")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                        let httpBody = NSMutableData()
                        
                        httpBody.appendString(self.convertFormField(named: "room_code", value: room_code!, using: boundary))
                        
                        httpBody.append(self.convertFileData(fieldName: "userfile",
                                                        fileName: "\(self.memberID()).json",
                                                        mimeType: "application/json",
                                                        fileData: fileJsonData,
                                                        using: boundary))
                        
                        httpBody.appendString("--\(boundary)--")
                        
                        request.httpBody = httpBody as Data

                        print(String(data: httpBody as Data, encoding: .utf8)!)
                        
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            let dataString = String(data: data!, encoding: .utf8)
                            print(dataString)
                        }.resume()
                        
                    } catch {
                        print("error:", error)
                    }
                    


                }
            }
            
            print("Erro", error, isFinal)
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.start.isEnabled = true
//                self.start.setTitle("Start Recording", for: [])
                self.performSegue(withIdentifier: "stop", sender: self)
            }
        }
        

        
        //configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // let the user know to start talking
//        txtlbl.text = "(Go ahead, i'm listening)"
    }
    // MARK: SFSpeechRecognizerDelegate
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            start.isEnabled = true
            start.setTitle("Start Recording", for: [])
        } else {
            start.isEnabled = false
            start.setTitle("Recognition Not Available", for: .disabled)
        }
    }
    
    // MARK: Generate Boundary String
    private func generateBoundaryString() -> String{
        let uuid = defaults.string(forKey: "UUID")!
        return "Boundary-\(uuid)"
    }
    
    func memberID() -> String{
        let uuid = defaults.string(forKey: "UUID")!
        return uuid
    }
    
    func room_code() -> String {
          return self.defaults.string(forKey: "room_code")!
    }
    
    
    // MARK: Create Body JSON
    // MARK: httpBody Request
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
   
    @IBAction func start(_ sender: UIButton){
        
        startRecord()
        if(isStart){
            startMeetingAPI()
            isStart = false
        }else{
            if(isHost){
                endMeetingAPI()
            }
        }
            
    }
    
    // MARK: Function to Start Button
    func startRecord(){
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            start.isEnabled = false
            start.setTitle("Stopping", for: .disabled)
        }else{
            do {
                try startRecording()
                start.setTitle("Stop Recording", for: [])
            }catch{
                start.setTitle("Recording Not Available", for: [])
            }
        }

    }
    
    
    func startMeetingAPI(){
       guard let gitURL = URL(string: "http://api.likeholidaybatam.com/start_meeting_room.php") else {return}
       
       var request = URLRequest(url: gitURL)
           request.httpMethod = "POST"
           
       
        let stringPost="host_id=\(self.defaults.string(forKey: "UUID")!)&room_code=\(self.defaults.string(forKey: "room_code")!)" // Key and Value 
        
            print(stringPost)
           let data = stringPost.data(using: .utf8)
               request.httpBody=data
             
       URLSession.shared.dataTask(with: request) { (data, respone, error) in
           
       guard let data = data else { return }
           do {
                let decoder = JSONDecoder()
                let roomData = try decoder.decode(StatusResponseJson.self, from: data)
           
            print(roomData.status)
            DispatchQueue.main.async {
                
                if roomData.status == false{
                    print("gagal kirim start")
                }else{
                    print("Berhasil Start")
                }
            }
                     
               
               }catch let err{
                    print("Error", err)
               }
           }.resume()
       }
    
    
    func endMeetingAPI(){
           guard let gitURL = URL(string: "http://api.likeholidaybatam.com/end_meeting_room.php") else {return}
           
           var request = URLRequest(url: gitURL)
            request.httpMethod = "POST"
               
           
            let stringPost="host_id=\(self.defaults.string(forKey: "UUID")!)&room_code=\(self.defaults.string(forKey: "room_code")!)" // Key and Value 
            
            print(stringPost)
            let data = stringPost.data(using: .utf8)
                   request.httpBody=data
                 
           URLSession.shared.dataTask(with: request) { (data, respone, error) in
               
           guard let data = data else { return }
               do {
                    let decoder = JSONDecoder()
                    let roomData = try decoder.decode(StatusResponseJson.self, from: data)
               
                print(roomData.status)
                DispatchQueue.main.async {
                    
                    if roomData.status == false{
                        print("gagal kirim start")
                    }else{
                        print("Berhasil Start")
                    }
                }
                         
                   
                   }catch let err{
                        print("Error", err)
                   }
               }.resume()
       }
    
    //MARK: Infinite Loop Timer Schedule with Interval
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
            let roomData = try JSONDecoder().decode(CheckStatusRoom.self, from: data)
           
            print(roomData.status!)
            DispatchQueue.main.async {
                
                if roomData.status! == false{
                    print("\(roomData.status)")
                    self.statusLabel.text="Wait for the Host to start the meeting"
                }else{
                    self.statusLabel.text="Ready"
                    self.startRecord()
                }
            }
                     
               
               }catch let err{
                    print("Error", err)
               }
           }.resume()
       }
    
    struct CheckStatusRoom: Encodable, Decodable {
        var status: Bool?
        let description: String?

        private enum CodingKeys: String, CodingKey{
          case status
          case description
       }
    }
   

}

// MARK: Extension NS Mutable Data
extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}


