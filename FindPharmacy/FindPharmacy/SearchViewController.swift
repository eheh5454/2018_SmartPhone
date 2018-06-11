//
//  SearchViewController.swift
//  FindPharmacy
//
//  Created by DoHyun on 2018. 5. 17..
//  Copyright © 2018년 DoHyun. All rights reserved.
//

import UIKit
import Speech

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var Search_County_District: UITextField!
    
    @IBOutlet weak var Start_County_District_Transcribe_Button: UIButton!
    @IBOutlet weak var Stop_County_District_Transcribe_Button: UIButton!
    
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var pickerview: UIPickerView!
    
    @IBAction func Search(_ sender: Any) {
        audioController.playerEffect(name: SoundDing)
        //파티클
        let explore = ExplodeView(frame:CGRect(x:(SearchButton.imageView?.center.x)!, y:(SearchButton.imageView?.center.y)!,width:10,height:10))
        SearchButton.imageView?.superview?.addSubview(explore)
        SearchButton.imageView?.superview?.sendSubview(toBack: explore)
    }
    
    @IBAction func Start_County_District_transcribe(_ sender: Any) {
        Start_County_District_Transcribe_Button.isEnabled = false
        Stop_County_District_Transcribe_Button.isEnabled = true
        try! startSession()
    }
    @IBAction func Stop_County_District_transcribe(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            Start_County_District_Transcribe_Button.isEnabled = true
            Stop_County_District_Transcribe_Button.isEnabled = false
        }
    }
    
    @IBAction func doneToSearch(segue:UIStoryboardSegue){
    }
    
    var audioController:AudioController
    required init?(coder aDecoder: NSCoder) {
        //AudioController 객체를 생성하고 오디오 파일 preload에서 dictionary에 넣는다
        audioController = AudioController()
        audioController.preloadAudioEffects(audioFileNames: AudioEffectFiles)
        super.init(coder: aDecoder)
    }

    
    var city = ""
    var city_utf8 = ""
    
    var count_district = ""
    var count_district_utf8 = ""
    
    var pickerDataSource = ["서울특별시","부산광역시","대구광역시","인천광역시","광주광역시","대전광역시",
                            "울산광역시","세종특별자치시","경기도","강원도","충청북도","충청남도","전라북도",
                            "전라남도","경상북도","경상남도","제주특별자치도"]
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //city = Search_City.text!
        //city = pickerDataSource[pickerview.dids]
        city_utf8 = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        count_district = Search_County_District.text!
        count_district_utf8 = count_district.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        if segue.identifier == "segueToPharmacy"{
            if let navController = segue.destination as? UINavigationController{
                if let viewController = navController.topViewController as?
                    ViewController_Pharmacy{
                    viewController.city_utf8 = city_utf8
                    viewController.count_district_utf8 = count_district_utf8
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
                
                self.Search_County_District.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                
                self.Start_County_District_Transcribe_Button.isEnabled = true
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
                    self.Start_County_District_Transcribe_Button.isEnabled = true
                    
                case .denied:
                    self.Start_County_District_Transcribe_Button.isEnabled = false
                    self.Start_County_District_Transcribe_Button.setTitle("Speech recognition access denied by user", for: .disabled)
                    
                case .restricted:
                    self.Start_County_District_Transcribe_Button.isEnabled = false
                    self.Start_County_District_Transcribe_Button.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.Start_County_District_Transcribe_Button.isEnabled = false
                    self.Start_County_District_Transcribe_Button.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    //시 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        city = pickerDataSource[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeSR()
        self.pickerview.delegate = self;
        self.pickerview.dataSource = self;

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
