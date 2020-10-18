//
//  User.swift
//  HomeX
//
//  Created by Mac on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
class User:NSObject, NSCoding {
    
    var usr_username_id:Int!
    var usr_first_name:String!
    var usr_last_name:String!
    var email:String!
    var api_token:String!
    
    var usr_status:String!
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.usr_username_id = aDecoder.decodeObject(forKey: "usr_username_id") as? Int
        self.usr_first_name = aDecoder.decodeObject(forKey: "usr_first_name") as? String
        self.usr_last_name = aDecoder.decodeObject(forKey: "usr_last_name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.api_token = aDecoder.decodeObject(forKey: "api_token") as? String
        
        self.usr_status = aDecoder.decodeObject(forKey: "usr_status") as? String
        
    }
    func encode(with acoder: NSCoder) {
        
        acoder.encode(self.usr_username_id,forKey: "usr_username_id")
        acoder.encode(self.usr_first_name,forKey: "usr_first_name")
        acoder.encode(self.usr_last_name,forKey: "usr_last_name")
        acoder.encode(self.email,forKey: "email")
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
