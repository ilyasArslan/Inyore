//
//  latestTruths.swift
//  Inyore
//
//  Created by Arslan on 11/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

class latestTruths: NSObject, Mappable{
    
    var id : Int?
    var ar_title : String?
    var ar_description : String?
    var ar_image_link : String?
    var ar_user_id : Int?
    var ar_status : Int?
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
        updated_at <- map["updated_at"]
        userviews <- map["userviews"]
        userpraises <- map["userpraises"]
        usercomments <- map["usercomments"]
        
        communities <- map["communities"]
        
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return latestTruths()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> latestTruths {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: latestTruths())
    }
}
