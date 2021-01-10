//
//  AuthService.swift
//  Stock
//
//  Created by TXB4 on 10/09/2020.
//  Copyright © 2020 TobaIbrahim. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    
    let email:String
    let password:String
    let username:String
    
}

struct AuthService {
    
    static let shared  = AuthService()
    static let uid     = Auth.auth().currentUser?.uid
    let ref            = Database.database().reference()
    
    private init () {}
    
    
    func logUserIn(withEmail email:String,password:String, completion:(AuthDataResultCallback?)) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
        
    }
    
    
    func registerUser(credentials:AuthCredentials,completetion:@escaping(Error?,DatabaseReference) -> Void) {
        
    
        let email     = credentials.email
        let password  = credentials.password
        let username  = credentials.username
        // setting the credentials values
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            // add info for database
            
            if let error = error {
                print("DEBUG: Could not register User \(error.localizedDescription)")
                return
                // handle error
            }
            
            print("DEBUG: Successfully registered user ")
            
            guard let uid = result?.user.uid else {return}
            // aquire the uid for the user
            
            let values = ["email":email,"password":password,"username":username]
            // create a dictionary for our database holding user info
            
            Database.database().reference().child("users").child(uid).updateChildValues(values,withCompletionBlock: completetion)
            // after the database is updated we add a complettion block for what to do after. this is called in the signup
        }
        
        print("Password is: \(password)")
        print("Email is: \(email)")

        
        
    }
    
    func uploadFollowers (key:String,value:String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [key:value]
        Database.database().reference().child("following").child(uid).updateChildValues(values)
                
    }
    
    
    func createDefaultAdUnit (key:String,value:String) {
        let values = [key:value]
        Database.database().reference().child("adUnitValue").updateChildValues(values)
                
    }
    
    
    
    func uploadProfileImageUrl(profileURL:String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let url = ["profileURL":profileURL]
        Database.database().reference().child("users").child(uid).updateChildValues(url)

    }
    
    func uploadShopImageUrl(ShopImageURL:String,shopName:String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let url = [shopName:ShopImageURL]
        Database.database().reference().child("following").child(uid).updateChildValues(url)

    }
    
    
    func resetPassword() {
        
        // put this in the Authservice
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ref.child("users").child(uid).queryOrderedByValue().observe(.value) { (snapshot) in
            
            let following       = snapshot.value as? NSDictionary
            guard let values    = following?.allValues else {return}
            guard let val       = values as? [String] else {return}
        Auth.auth().sendPasswordReset(withEmail: val[0]) { (error) in
            
        }
    }
    

}
    
    func changeUsername(newUsername:String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["username":newUsername]
        Database.database().reference().child("users").child(uid).updateChildValues(values)
    }
    
    

        func accountType() -> String{
        // checks if account is premium
        var type = String()
        let uid = Auth.auth().currentUser?.uid
//        print("DEBUG: UID = \(uid)")
            ref.child("users").child(uid!).observe(.value) { (snapshot) in
            let accountType         = snapshot.value as? NSDictionary
            guard let values        = accountType?.allValues else {return}
            guard let val           = values as? [String] else {return}
            type = val[1]
            print("DEBUG: ACC TYPE = \(type)")
        }
        return type
        
    }
    
    func premiumActivated(type:String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["Premium":type]
        Database.database().reference().child("users").child(uid).updateChildValues(values)
    }
    
    
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {return}
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        user.delete { (error) in
            print("DEBUG: User deleted")
        }
        Database.database().reference().child("users").child(uid).removeValue()
        // add later
    }
    
    func forgotPassword(email:String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        
        }
    }
    
    
    
    
    
    
    
//
//    func getApiKey() {
//
//        ref.child("key").observe(.value) { (snapshot) in
//            let key             = snapshot.value as? NSDictionary  // set snapshot as dict
//            guard let values    = key?.allValues else {return} // access all values in dict
//            guard let val       = values as? [String] else {return}
//            apk                 = val[0]
//
//            print("DEBUG: APK = \(val[0])")
//        }

}
    

