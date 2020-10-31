//
//  Articles.swift
//  Inyore
//
//  Created by Arslan on 13/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

class Articles: NSObject, Mappable{
    
    var id : Int?
    var ar_title : String?
    var ar_description : String?
    var ar_image_link : String?
    var ar_user_id : Int?
    var ar_status : Int?
    var created_at: String?
    var updated_at : String?
    var userviews : Int?
    var userpraises : Int?
    var usercomments : Int?
    
    var communities : [Communities]?
    
    required init?(map: Map) {}
    override init(){}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        ar_title <- map["ar_title"]
        ar_description <- map["ar_description"]
        ar_image_link <- map["ar_image_link"]
        ar_user_id <- map["ar_user_id"]
        ar_status <- map["ar_status"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        userviews <- map["userviews"]
        userpraises <- map["userpraises"]
        usercomments <- map["usercomments"]
        
        communities <- map["communities"]
        
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return Articles()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> Articles {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: Articles())
    }
}
