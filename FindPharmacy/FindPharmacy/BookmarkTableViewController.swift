//
//  BookmarkTableViewController.swift
//  FindPharmacy
//
//  Created by DoHyun on 2018. 5. 28..
//  Copyright © 2018년 DoHyun. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var posts = NSMutableArray()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection numberOfRowsInSectionsection: Int) -> Int
    {
        return posts.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkcell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row] as! String
        return cell
    }
    
    func reload(){
        table!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
