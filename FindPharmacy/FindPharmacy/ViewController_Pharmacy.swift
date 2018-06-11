//
//  ViewController_Pharmacy.swift
//  FindPharmacy
//
//  Created by DoHyun on 2018. 5. 20..
//  Copyright © 2018년 DoHyun. All rights reserved.
//

import UIKit
import MapKit

class ViewController_Pharmacy: UIViewController, XMLParserDelegate, UITableViewDataSource {
    @IBOutlet weak var tbData: UITableView!
    
    
    @IBAction func doneToPharmacyTable(segue:UIStoryboardSegue){
        
    }
    //이전페이지로 넘어가기
    @IBAction func BeforePage(_ sender: Any) {
        if (pageNum > 1){
            pageNum -= 1
            url = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=ZFUVcAyJirpdcu5jQmz0TDQ2rLktWOxLAhz9E5nehG6dht019PS7gjG64Amz4NwEe1cmeBeDOQDnmoAGifCvfw%3D%3D&Q0=\(city_utf8)&Q1=\(count_district_utf8)&QT=1&ORD=NAME&pageNo=\(pageNum)&startPage=1&numOfRows=20&pageSize=20"
            beginParsing()
        }
        
    }
    
    //다음페이지로 넘어가기
    @IBAction func NextPage(_ sender: Any) {
        pageNum += 1
        url = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=ZFUVcAyJirpdcu5jQmz0TDQ2rLktWOxLAhz9E5nehG6dht019PS7gjG64Amz4NwEe1cmeBeDOQDnmoAGifCvfw%3D%3D&Q0=\(city_utf8)&Q1=\(count_district_utf8)&QT=1&ORD=NAME&pageNo=\(pageNum)&startPage=1&numOfRows=20&pageSize=20"
        beginParsing()
    }
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var title1 = NSMutableString()
    var tel = NSMutableString()
    var hpid = NSMutableString()
    
    var XPos = NSMutableString()
    var YPos = NSMutableString()
    
    var city_utf8 = ""
    var count_district_utf8 = ""
    
    var url:String?
    
    var pharmacycode = ""
    
    var pageNum:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=ZFUVcAyJirpdcu5jQmz0TDQ2rLktWOxLAhz9E5nehG6dht019PS7gjG64Amz4NwEe1cmeBeDOQDnmoAGifCvfw%3D%3D&Q0=\(city_utf8)&Q1=\(count_district_utf8)&QT=1&ORD=NAME&pageNo=1&startPage=1&numOfRows=20&pageSize=20"
        beginParsing()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to:"item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            tel = NSMutableString()
            tel = ""
            hpid = NSMutableString()
            hpid = ""
            
            //위도 경도
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "dutyName"){
            title1.append(string)
        }else if element.isEqual(to: "dutyMapimg"){
            tel.append(string)
        }else if element.isEqual(to: "hpid"){
            hpid.append(string)
        }
        //위도 경도 찾기
        else if element.isEqual(to: "wgs84Lat"){
            XPos.append(string)
        }
        else if element.isEqual(to: "wgs84Lon"){
            YPos.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item"){
            if !title1.isEqual(nil){
                elements.setObject(title1, forKey: "dutyName" as NSCopying)
            }
            if !tel.isEqual(nil){
                elements.setObject(tel, forKey: "dutyMapimg" as NSCopying)
            }
            if !hpid.isEqual(nil){
                elements.setObject(hpid, forKey: "hpid" as NSCopying)
            }
            //위도 경도
            if !XPos.isEqual(nil){
                elements.setObject(XPos, forKey: "XPos" as NSCopying)
            }
            if !YPos.isEqual(nil){
                elements.setObject(YPos, forKey: "YPos" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection numberOfRowsInSectionsection: Int) -> Int
    {
        return posts.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyName") as!
            NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyMapimg") as!
            NSString as String
        return cell
    }
    
    //맵뷰로 넘어가면서 세그를 확인하고 첫번째 약국의 경도와 위도를 넘겨준다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToMapView"{
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.posts = posts
                mapViewController.lat = (posts[0] as AnyObject).value(forKey: "XPos") as! String
                mapViewController.lon = (posts[0] as AnyObject).value(forKey: "YPos") as! String

            }
        }
    
        if segue.identifier == "segueToPharmacyDetail"{
            if let cell = sender as? UITableViewCell{
                let indexPath = tbData.indexPath(for: cell)
                pharmacycode = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "hpid") as! NSString as String
                if let navController = segue.destination as? UINavigationController{
                    if let detailPharmacyTableViewController = navController.topViewController as? DetailPharmacyTableViewController{
                        detailPharmacyTableViewController.url = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyBassInfoInqire?serviceKey=ZFUVcAyJirpdcu5jQmz0TDQ2rLktWOxLAhz9E5nehG6dht019PS7gjG64Amz4NwEe1cmeBeDOQDnmoAGifCvfw%3D%3D&HPID=\(pharmacycode)&pageNo=1&startPage=1&numOfRows=10&pageSize=10"
                    }
                }
            }
        }
    }
}
