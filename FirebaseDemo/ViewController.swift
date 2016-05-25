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
    
    @IBOutlet weak var messageBar: UIView!
    
    var messages:[FIRDataSnapshot] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.ref = FIRDatabase.database().reference().child("messages")
        
        //FETCHES MESSAGES
        self.ref.observeEventType(.Value, withBlock: { (snapshot) in
            //print(snapshot.value!)
            self.messages = []
            
            for msg in snapshot.children.allObjects {
                self.messages.append(msg as! FIRDataSnapshot)
                //print(msg.value["text"] as! NSString)
            }
            //print(self.messages[0].value!)
            //self.counter = self.messages.count
            self.tableView.reloadData()
            //self.ref.removeAllObservers()
            //print(self.messages[0].value!["text"] as! NSString)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        
        cell.textLabel?.text = self.messages[indexPath.row].value!["text"] as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMsg(sender: AnyObject) {
        
        //SAVES ON FIREBASE DATABASE
        let key = ref.childByAutoId().key
        //let newMsg = ["text": "abc001"+String(self.messages.count+1)]
        //let childUpdates = ["/msg\(self.messages.count+1)":newMsg]
        let newMsg = ["text":self.txtMsg.text! as String]
        let childUpdates = ["/\(key)":newMsg]
        self.ref.updateChildValues(childUpdates)
 
        self.view.endEditing(true)
    }
}

