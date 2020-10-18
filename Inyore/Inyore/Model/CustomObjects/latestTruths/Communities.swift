//
//  Communities.swift
//  Inyore
//
//  Created by Arslan on 11/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

class Communities: NSObject, Mappable{
    
    var id : Int?
    var cy_title : String?
    var cy_description : String?
    var cy_image_link : String?
    var cy_is_private : Int?
    var cy_user_id : Int?
    var cy_status : Int?
    
    var already_joined : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        cy_title <- map["cy_title"]
        cy_description <- map["cy_description"]
        cy_image_link <- map["cy_image_link"]
        cy_is_private <- map["cy_is_private"]
        cy_user_id <- map["cy_user_id"]
        cy_status <- map["cy_status"]
        
        already_joined <- map["already_joined"]

    }
    
    class func newInstance(map: Map) -> Mappable?{
        return Communities()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> Communities {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: Communities())
    }
    
}
