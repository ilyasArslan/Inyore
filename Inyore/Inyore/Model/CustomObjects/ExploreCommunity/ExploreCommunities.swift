//
//  ExploreCommunities.swift
//  Inyore
//
//  Created by Arslan on 14/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

class ExploreCommunities: NSObject, Mappable{

    var id : Int?
    var cy_title : String?
    var cy_description : String?
    var cy_image_link : String?
    var members : Int?
    var created_at : String?

    
    required init?(map: Map) {}
    override init(){}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        cy_title <- map["cy_title"]
        cy_description <- map["cy_description"]
        cy_image_link <- map["cy_image_link"]
        members <- map["members"]
        created_at <- map["created_at"]
        
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return ExploreCommunities()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> ExploreCommunities {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: ExploreCommunities())
    }
}
