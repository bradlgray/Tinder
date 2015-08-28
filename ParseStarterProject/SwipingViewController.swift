//
//  SwipingViewController.swift
//  ParseStarterProject
//
//  Created by Brad Gray on 8/25/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userInfo: UILabel!
    
    var displayedUserId = ""
    
    
    // func does all the heavy lifting by moving left or right, shrinking as it gets farther from center
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(90 / abs(xFromCenter), 1)
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedorRejected = ""
            
            if label.center.x < 100 {
                acceptedorRejected = "rejected"
            } else if label.center.x > self.view.bounds.width - 100 {
                acceptedorRejected = "accepted"
            }
            
            if acceptedorRejected != "" {
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey:acceptedorRejected)

                PFUser.currentUser()?.save()
            }
            
          
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height / 2 )
       
            
            
            
            updateImage()
        }
    }

    
    func updateImage() {
        var query = PFUser.query()!
        
        if let latitude = PFUser.currentUser()?["location"]!.latitude {
            if let longitude = PFUser.currentUser()?["location"]!.longitude {
                
                 query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast:PFGeoPoint(latitude:latitude + 1, longitude: longitude + 1))
            }
        }
        
        
        
        
        
        var interestedIn = "male"
        
        if PFUser.currentUser()!["interestedInWomen"]! as! Bool == true {
            interestedIn = "female"
            
        }
        
        var isFemale = true
        
        if PFUser.currentUser()?["gender"]! as! String == "male" {
            isFemale = false
        }
        query.whereKey("gender", equalTo: interestedIn)
        query.whereKey("interestedInWomen", equalTo: isFemale)
        
        var ignoredUsers = [""]
        
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
            
                     }
       
        if let rejectedUsers = PFUser.currentUser()?["rejected"]{
            
            ignoredUsers += rejectedUsers as! Array
            
           
        }
        
         query.whereKey("objecId", notContainedIn: ignoredUsers)
    
    
    query.limit = 1
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print(error)
            } else if let objects = objects as? [PFObject] {
                
                for object in objects {
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            print(error)
                        } else {
                            if let data = imageData {
                                self.userImage.image = UIImage(data: data)
                            }
                        }
                    }
                }
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        userImage.addGestureRecognizer(gesture)
        
        userImage.userInteractionEnabled = true
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            if let geoPoint = geoPoint {
                PFUser.currentUser()?["location"] = geoPoint
                PFUser.currentUser()?.save()
                
            }
        }
        
        updateImage()

         }

    override func didReceiveMemoryWarning() {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logOut" {
            PFUser.logOut()
        }
    }

    }
