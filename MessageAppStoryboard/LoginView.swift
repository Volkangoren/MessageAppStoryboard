//
//  ViewController.swift
//  MessageAppStoryboard
//
//  Created by Volkan on 12.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import UIKit
import Firebase


class LoginView: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: nil, action: #selector(logOut))
        

    }

    @objc func logOut() {
        do{
         try Auth.auth().signOut()
        }catch{
            print("logout error")
        }
    }

    @IBAction func signInButton(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "ERROR")
                }else {
                    self.performSegue(withIdentifier: "toUserView", sender: nil)
                }
            }
            
        }else {
            makeAlert(titleInput: "ERROR!", messageInput: "Email,password and username required!")
        }
            
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" && usernameText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "ERROR")
                }else {
                    //Database
                    var ref : DocumentReference?
                    let UserInfos = [ "userEmail" : self.emailText.text , "userName" : self.usernameText.text , "userIdFromFirebase" : authdata?.user.uid] as [String : Any]
                    
                    ref = self.db.collection("UserInfo").addDocument(data: UserInfos, completion: { (error) in
                        if error != nil {
                            self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "ERROR")
                        }
                    })
                    
                    self.performSegue(withIdentifier: "toUserView", sender: nil)
                }
            }
        }else {
            makeAlert(titleInput: "ERROR!", messageInput: "Email, username and password required!")
        }
     
        
            
        
        
    }
    
    
    
    
    
    func makeAlert(titleInput : String , messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion: nil)
    }
}

