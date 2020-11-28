//
//  Notifications.swift
//  Inyore
//
//  Created by Arslan on 20/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

class Notifications: NSObject, Mappable{
    
    var id: Int?
    var nt_community_id : Int?
    var nt_article_id : Int?
    var nt_comment_id : Int?
    var ca_id: Int?
    var created_at : String?
    var ct_message : String?
    var ar_title : String?
    var cy_title : String?
    var ca_title: String?
    var rd_username : String?
    var is_viewed : Int?
    
    required init?(map: Map) {}
    override init(){}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        nt_community_id <- map["nt_community_id"]
        nt_article_id <- map["nt_article_id"]
        nt_comment_id <- map["nt_comment_id"]
        ca_id <- map["ca_id"]
        created_at <- map["created_at"]
        ct_message <- map["ct_message"]
        ar_title <- map["ar_title"]
        cy_title <- map["cy_title"]
        ca_title <- map["ca_title"]
        rd_username <- map["rd_username"]
        is_viewed <- map["is_viewed"]
        
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return Notifications()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> Notifications {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: Notifications())
    }
}
