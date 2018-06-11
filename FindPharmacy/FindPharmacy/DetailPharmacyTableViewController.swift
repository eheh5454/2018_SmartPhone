//
//  DetailPharmacyTableViewController.swift
//  FindPharmacy
//
//  Created by DoHyun on 2018. 5. 27..
//  Copyright © 2018년 DoHyun. All rights reserved.
//

import UIKit


class DetailPharmacyTableViewController: UITableViewController, XMLParserDelegate {
    @IBOutlet var detailTableView: UITableView!
    
    @IBAction func AddToBookmark(_ sender: Any) {
        cposts.add(posts[0])
    }
    
    var url: String?
    
    var parser = XMLParser()
    
    let postsname : [String] = ["약국이름","주소","상세주소","전화번호","평일 오픈시간","평일 마감시간", "주말 오픈시간", "주말 마감시간"]
    
    var posts: [String] = ["","","","","","","",""]
    
    var element = NSString()
    
    var name = NSMutableString()
    var addr = NSMutableString()
    var detailaddr = NSMutableString()
    var tell = NSMutableString()
    var weekopen = NSMutableString()
    var weekclose = NSMutableString()
    var weekendopen = NSMutableString()
    var weekendclose = NSMutableString()
    
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "item")
        {
            posts = ["","","","","","","",""]
            name = NSMutableString()
            name = ""
            addr = NSMutableString()
            addr = ""
            detailaddr = NSMutableString()
            detailaddr = ""
            tell = NSMutableString()
            tell = ""
            weekopen = NSMutableString()
            weekopen = ""
            weekclose = NSMutableString()
            weekclose = ""
            weekendopen = NSMutableString()
            weekendclose = ""
            weekendclose = NSMutableString()
            weekendclose = ""
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyName"){
            name.append(string)
        } else if element.isEqual(to: "dutyAddr"){
            addr.append(string)
        } else if element.isEqual(to: "dutyMapimg"){
            detailaddr.append(string)
        } else if element.isEqual(to: "dutyTell"){
            tell.append(string)
        } else if element.isEqual(to: "dutyTime1s"){
            weekopen.append(string)
        } else if element.isEqual(to: "dutyTime1c"){
            weekclose.append(string)
        } else if element.isEqual(to: "dutyTime7s"){
            weekendopen.append(string)
        } else if element.isEqual(to: "dutyTime7c"){
            weekendclose.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item"){
            if !name.isEqual(nil){
                posts[0] = name as String
            }
            if !addr.isEqual(nil){
                posts[1] = addr as String
            }
            if !detailaddr.isEqual(nil){
                posts[2] = detailaddr as String
            }
            if !tell.isEqual(nil){
                posts[3] = tell as String
            }
            if !weekopen.isEqual(nil){
                posts[4] = weekopen as String
            }
            if !weekclose.isEqual(nil){
                posts[5] = weekclose as String
            }
            if !weekendopen.isEqual(nil){
                posts[6] = weekendopen as String
            }
            if !weekendclose.isEqual(nil){
                posts[7] = weekendclose as String
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCell", for: indexPath)
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
}
