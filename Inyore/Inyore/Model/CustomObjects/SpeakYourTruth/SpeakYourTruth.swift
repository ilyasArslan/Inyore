//
//  SpeakYourTruth.swift
//  Inyore
//
//  Created by Arslan on 14/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

class SpeakYourTruth: NSObject, Mappable{
    
    var id : Int?
    var cy_title : String?
    var cy_description : String?
    var cy_image_link : String?
    var cy_is_private : Int?
    var created_at : String?
    var members : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        cy_title <- map["cy_title"]
        cy_description <- map["cy_description"]
        cy_image_link <- map["cy_image_link"]
        cy_is_private <- map["cy_is_private"]
        created_at <- map["created_at"]
        members <- map["members"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return SpeakYourTruth()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> SpeakYourTruth {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: SpeakYourTruth())
    }
}
