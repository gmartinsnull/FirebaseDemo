//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Glauber Martins on 2016-05-20.
//  Copyright © 2016 Glauber Martins. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMsg: UITextField!
    var ref:FIRDatabaseReference!
    
    var messages:[FIRDataSnapshot] = []
    
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //var messagesDBRef = FIRDatabase.reference("https://fir-demo-37e4a.firebaseio.com/messages")
        //messagesDBRef = FIRDatabase.database().reference()
        
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("messages").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            //print(snapshot.value!)
            
            for txt in snapshot.children {
                self.messages.append(txt as! FIRDataSnapshot)
                
            }
            
            //print(self.messages[0].value!)
            //self.counter = self.messages.count
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        //cell.textLabel!.text="row#\(indexPath.row)"
        //cell.detailTextLabel!.text="subtitle#\(indexPath.row)"
        cell.textLabel?.text = self.messages[indexPath.row].value as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMsg(sender: AnyObject) {
        //SAVES ON FIREBASE
        
        let key = self.ref.child("messages").childByAutoId().key
        let msg = ["text": "abc001"+String(self.messages.count+1)]
        let childUpdates = ["/messages/\(key)": msg]
        self.ref.updateChildValues(childUpdates)
        //counter += 1
        
        //ADDS ON TABLEVIEW
        self.ref.observeEventType(.ChildAdded, withBlock: {(snapshot) -> Void in
            self.messages.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:self.messages.count-1, inSection:0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            NSLog("%@", self.messages)
        })
    }

}

