//
//  SearchViewController.swift
//  FindPharmacy
//
//  Created by DoHyun on 2018. 5. 17..
//  Copyright © 2018년 DoHyun. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var Search_City: UITextField!
    @IBOutlet weak var Search_County_District: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
