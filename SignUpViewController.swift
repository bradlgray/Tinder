//
//  SignUpViewController.swift
//  ParseStarterProject
//
//  Created by Brad Gray on 8/25/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UITableViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    
    @IBOutlet weak var interestedInWomen: UISwitch!
    
    @IBAction func signUp(sender: UIButton) {
        PFUser.currentUser()?["interestedInWomen"] = interestedInWomen.on
        PFUser.currentUser()?.save()
        
    }
    
    override func viewDidLoad() {
        //image urls
        
        let urlArray = ["http://www.slate.com/content/dam/slate/blogs/xx_factor/2013/10/10/disney_animator_on_creating_the_two_princesses_of_frozen_female_characters/1381432779.jpg.CROP.promovar-mediumlarge.jpg", "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=1760886", "http://www.hdtabletwallpaper.com/var/albums/Beautiful%20League%20of%20Legends%20female%20champions%20wallpapers%201024x1024/Beautiful%20League%20of%20Legends%20female%20champions%20wallpapers%201024x1024%20(01).jpg?m=1358834282", "http://allcartooncharacters.com/wp-content/uploads/2014/05/Ariel-The-Little-Mermaid.jpg"]
        
        var counter = 1
        
        for url in urlArray {
            let nsurl = NSURL(string: url)!
            
            if let data = NSData(contentsOfURL: nsurl) {
                self.userImage.image = UIImage(data: data)
                
                let imageFile: PFFile = PFFile(data: data)
                
                var user:PFUser = PFUser()
                
                var username = "user\(counter)"
                
                user.password = "pass"
                
                user["image"] = imageFile
                user["interestedInWomen"] = false
                user["gender"] = "female"
                
                counter++
                user.signUp()
            }
            
        }
        
        
        super.viewDidLoad()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
        
        graphRequest.startWithCompletionHandler( {
            
            (connection, result, error) -> Void in
            
            if error != nil {
                print(error)
            } else if let result = result {
                PFUser.currentUser()?["gender"] = result["gender"]
                PFUser.currentUser()?["name"] = result["name"]
                
                PFUser.currentUser()?.save()
                
                let userId = result["id"] as! String
                
                let facebookProfilePictureURL = "https://graph.faceboook.com/" + userId + "picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureURL) {
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        self.userImage.image = UIImage(data: data)
                        
                        let imageFile: PFFile = PFFile(data: data)
                        
                        PFUser.currentUser()?["image"] = imageFile
                        PFUser.currentUser()?.save()
                    }
                    
                }
                
                
                
            }
            
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}
