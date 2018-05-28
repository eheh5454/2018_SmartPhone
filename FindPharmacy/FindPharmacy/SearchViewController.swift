//
//  SearchViewController.swift
//  FindPharmacy
//
//  Created by DoHyun on 2018. 5. 17..
//  Copyright © 2018년 DoHyun. All rights reserved.
//

import UIKit
import Speech

class SearchViewController: UIViewController {
    @IBOutlet weak var Search_City: UITextField!
    @IBOutlet weak var Search_County_District: UITextField!
    
    @IBOutlet weak var Start_City_Transcribe_Button: UIButton!
    @IBOutlet weak var Stop_City_Transcribe_Button: UIButton!
    
    @IBAction func Start_City_transcribe(_ sender: Any) {
        Start_City_Transcribe_Button.isEnabled = false
        Stop_City_Transcribe_Button.isEnabled = true
        try! startSession()
    }
    @IBAction func Stop_City_transcribe(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            Start_City_Transcribe_Button.isEnabled = true
            Stop_City_Transcribe_Button.isEnabled = false
        }
    }
    
    @IBAction func doneToSearch(segue:UIStoryboardSegue){
        
    }
    var city = ""
    var city_utf8 = ""
    
    var count_district = ""
    var count_district_utf8 = ""
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        city = Search_City.text!
        city_utf8 = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        count_district = Search_County_District.text!
        count_district_utf8 = count_district.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        if segue.identifier == "segueToPharmacy"{
            if let navController = segue.destination as? UINavigationController{
                if let viewController = navController.topViewController as?
                    ViewController_Pharmacy{
                    viewController.url = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=ZFUVcAyJirpdcu5jQmz0TDQ2rLktWOxLAhz9E5nehG6dht019PS7gjG64Amz4NwEe1cmeBeDOQDnmoAGifCvfw%3D%3D&Q0=\(city_utf8)&Q1=\(count_district_utf8)&QT=1&ORD=NAME&pageNo=1&startPage=1&numOfRows=20&pageSize=20"
                }
            }
        }
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier:"ko-Kr"))!
    
    private var speechRecognitionRequest:
    SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func startSession() throws {
        
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else { fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed") }
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            var finished = false
            
            if let result = result {
                
                self.Search_City.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                
                self.Start_City_Transcribe_Button.isEnabled = true
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func authorizeSR() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.Start_City_Transcribe_Button.isEnabled = true
                    
                case .denied:
                    self.Start_City_Transcribe_Button.isEnabled = false
                    self.Start_City_Transcribe_Button.setTitle("Speech recognition access denied by user", for: .disabled)
                    
                case .restricted:
                    self.Start_City_Transcribe_Button.isEnabled = false
                    self.Start_City_Transcribe_Button.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.Start_City_Transcribe_Button.isEnabled = false
                    self.Start_City_Transcribe_Button.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeSR()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
