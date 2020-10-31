//
//  User.swift
//  HomeX
//
//  Created by Mac on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
class User:NSObject, NSCoding {
    
    var id: Int!
    var usr_username_id:Int!
    var usr_first_name:String!
    var usr_last_name:String!
    var full_username: String!
    var email:String!
    
    var remember_token: String!
    var api_token:String!
    
    var usr_status:String!
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.usr_username_id = aDecoder.decodeObject(forKey: "usr_username_id") as? Int
        self.full_username = aDecoder.decodeObject(forKey: "full_username") as? String
        self.usr_first_name = aDecoder.decodeObject(forKey: "usr_first_name") as? String
        self.usr_last_name = aDecoder.decodeObject(forKey: "usr_last_name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        
        self.remember_token = aDecoder.decodeObject(forKey: "remember_token") as? String
        self.api_token = aDecoder.decodeObject(forKey: "api_token") as? String
        
        self.usr_status = aDecoder.decodeObject(forKey: "usr_status") as? String
        
    }
    func encode(with acoder: NSCoder) {
        
        acoder.encode(self.id,forKey: "id")
        acoder.encode(self.usr_username_id,forKey: "usr_username_id")
        acoder.encode(self.full_username,forKey: "full_username")
        acoder.encode(self.usr_first_name,forKey: "usr_first_name")
        acoder.encode(self.usr_last_name,forKey: "usr_last_name")
        acoder.encode(self.email,forKey: "email")
        
        acoder.encode(self.remember_token, forKey: "remember_token")
        acoder.encode(self.api_token, forKey: "api_token")
        
        acoder.encode(self.usr_status, forKey: "usr_status")
        
    }
    //MARK: Archive Methods
        class func archiveFilePath() -> String {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsDirectory.appendingPathComponent("user.archive").path
        }
        
        class func readUserFromArchive() -> [User]? {
            return NSKeyedUnarchiver.unarchiveObject(withFile: archiveFilePath()) as? [User]
        }
        
        class func saveUserToArchive(user: [User]) -> Bool {
            return NSKeyedArchiver.archiveRootObject(user, toFile: archiveFilePath())
        }
        
    }
