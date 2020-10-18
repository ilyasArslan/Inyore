//
//  NewsFeed.swift
//  Inyore
//
//  Created by Arslan on 13/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

class NewsFeed: NSObject, Mappable{
    
    var title : String?
    var abstract : String?
    var url : String?
    var thumbnail_standard : String?
    
    required init?(map: Map) {}
    override init(){}
    
    func mapping(map: Map) {
        
        title <- map["title"]
        abstract <- map["abstract"]
        url <- map["url"]
        thumbnail_standard <- map["thumbnail_standard"]
        
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return NewsFeed()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> NewsFeed {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: NewsFeed())
    }
}
