//
//  ChatVC.swift
//  MessageAppStoryboard
//
//  Created by Volkan on 17.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import UIKit
import Firebase


class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageText: UITextField!
    let db = Firestore.firestore()
    var selectedUser : String = ""
    var selectedUserId : String = ""
     
    
    var messages : [String] = []
    var messageFrom : String = ""
    var messageTo : String = ""
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = selectedUser
        getDataFromFireStore()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    

    @IBAction func sendButton(_ sender: Any) {

        sendMessageToFirebase()
        print(messageFrom)
        print(messageTo)
        print(selectedUserId)
        print(Auth.auth().currentUser?.uid)
               
    }
    
    func sendMessageToFirebase () {
        var ref : DocumentReference? = nil
        
        let myChatDictionary : [String : Any] = ["chatUserFrom" : Auth.auth().currentUser?.uid, "chatUserTo" : self.selectedUserId, "date":generateDate(),"message":self.messageText.text]
        
        ref = self.db.collection("Chat").addDocument(data: myChatDictionary, completion: { (error) in
            if error != nil {
                
            }else {
                self.messageText.text = ""
            }
        })
    }
    func generateDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
   
    func getDataFromFireStore() {

        self.db.collection("Chat").whereField("chatUserFrom", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                self.messages.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    if let chatMessage = document.get("message") as? String{
                        if let messageFromFB = document.get("chatUserFrom") as? String{
                            if let messageToFB = document.get("chatUserTo") as? String {
                                if let dateString = document.get("date") as? String {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
                                    
                                    let dateFromFirebase = formatter.date(from: dateString)
                                    
                                    self.messageFrom = Auth.auth().currentUser!.uid
                                    self.messageTo = messageToFB
                                    self.messages.append(chatMessage)
                                }
                            }
                        }
                    }
                }
                
                self.db.collection("Chat").whereField("chatUserTo", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener { (snapshot, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }else {
                        self.messages.removeAll(keepingCapacity: false)
                        for document in snapshot!.documents {
                            if let chatMessage = document.get("message") as? String{
                                if let messageFromFB = document.get("chatUserFrom") as? String{
                                    if let messageToFB = document.get("chatUserTo") as? String {
                                        if let dateString = document.get("date") as? String {
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
                                            
                                            let dateFromFirebase = formatter.date(from: dateString)

                                            
                                            self.messageTo = Auth.auth().currentUser!.uid
                                            self.messageFrom = messageFromFB
                                            self.messages.append(chatMessage)
                                            
                                }
                            }
                        }
                    }
                }
                        self.tableView.reloadData()
            }
        }
    }
  }
}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messageFrom == Auth.auth().currentUser?.uid && messageTo == selectedUserId {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatCell
            cell.messageCame?.text = self.messages[indexPath.row]
            return cell
        }else if messageFrom == selectedUserId && messageTo == Auth.auth().currentUser?.uid {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! Chat2Cell
            cell2.messageSend?.text = self.messages[indexPath.row]
            return cell2
        }
        else {
            //No data
            let cell = UITableViewCell()
            cell.textLabel?.text = ""
            return cell
    }
  }
}
