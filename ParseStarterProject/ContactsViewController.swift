//
//  ContactsViewController.swift
//  ParseStarterProject
//
//  Created by Brad Gray on 8/27/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ContactsViewController: UITableViewController {
    
    var emails = [String]()
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

      var query = PFUser.query()!
        query.whereKey("accepted", equalTo: PFUser.currentUser()!.objectId!)
        query.whereKey("objectId", containedIn: PFUser.currentUser()?["accepted"] as! [String])
        
        query.findObjectsInBackgroundWithBlock{ (results, error) -> Void in
            if let results = results {
                for result in results as! [PFUser]{
                    self.emails.append(result["email"]! as! String)
                    
                    let imageFile = result["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            print(error)
                        } else {
                            if let data = imageData {
                                self.images.append(UIImage(data: data)!)
                                
                                self.tableView.reloadData()
                            }
                        }
                    }

                    
                }
                self.tableView.reloadData()
            }
    
        }
            }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.emails.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        
        cell.textLabel?.text = emails[indexPath.row]
        
        
        if images.count > indexPath.row {
            cell.imageView?.image = images[indexPath.row]
        }
        
        
        
        return cell
    }

  /* load up mail app
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let url = NSURL(string: "mailto:" + emails[indexPath.row])
        
        UIApplication.sharedApplication().openURL(url!)
    }
   */
}
