//
//  UserView.swift
//  MessageAppStoryboard
//
//  Created by Volkan on 12.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import UIKit
import Firebase

class UserView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var deneme = "deneme"
    var userNameFromFirebase : [String] = []
    var userUidFromFirebase : [String] = []
    var choosenUser : String = ""
    var choosenUserId : String = ""
    let db = Firestore.firestore()

    @IBOutlet weak var userTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserNameFromFirebase()
        // Do any additional setup after loading the view.
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
    }
    
    
    func getUserNameFromFirebase() {
        db.collection("UserInfo").addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            }else {
                self.userNameFromFirebase.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    if let userIdFromFirebase = document.get("userIdFromFirebase") as? String {
                    if let userName = document.get("userName") as? String {
                        
                        self.userNameFromFirebase.append(userName)
                        self.userTableView.reloadData()
                        self.userUidFromFirebase.append(userIdFromFirebase)
                    }
                    }
                }
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameFromFirebase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userNameFromFirebase[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenUser = userNameFromFirebase[indexPath.row]
        choosenUserId = userUidFromFirebase[indexPath.row]
        
        
        performSegue(withIdentifier: "toChatVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatVC" {
            let destinationViewController = segue.destination as! ChatVC
            destinationViewController.selectedUser = choosenUser
            destinationViewController.selectedUserId = choosenUserId
            
        }
    }
    func makeAlert(titleInput : String , messageInput : String) {
           let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
           let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(okButton)
           self.present(alert, animated: true,completion: nil)
       }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
