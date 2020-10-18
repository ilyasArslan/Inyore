//
//  BeHeard.swift
//  Inyore
//
//  Created by Arslan on 15/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ObjectMapper

//MARK:- Model of BeHeard
class BeHeard: NSObject, Mappable{
    
    var incomes : [states]?
    var departments : [departments]?
    var generations : [generations]?
    var genders : [genders]?
    var races : [races]?
    var industries : [industries]?
    var countries : [countries]?
    var states : [states]?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        incomes <- map["incomes"]
        departments <- map["departments"]
        generations <- map["generations"]
        genders <- map["genders"]
        races <- map["races"]
        industries <- map["industries"]
        countries <- map["countries"]
        states <- map["states"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return BeHeard()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> BeHeard {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: BeHeard())
    }
}

//MARK:- Model of incomes
class incomes: NSObject, Mappable {
    
    var id : Int?
    var ic_name : String?
    var ic_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        ic_name <- map["ic_name"]
        ic_status <- map["ic_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return incomes()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> incomes {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: incomes())
    }
}

//MARK:- Model of departments
class departments: NSObject, Mappable {
    
    var id : Int?
    var dt_name : String?
    var dt_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        dt_name <- map["dt_name"]
        dt_status <- map["dt_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return departments()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> departments {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: departments())
    }
}

//MARK:- Model of generation
class generations: NSObject, Mappable {
    
    var id : Int?
    var gn_name : String?
    var gn_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        gn_name <- map["gn_name"]
        gn_status <- map["gn_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return generations()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> generations {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: generations())
    }
}

//MARK:- Model of gender
class genders: NSObject, Mappable {
    
    var id : Int?
    var gd_name : String?
    var gd_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        gd_name <- map["gd_name"]
        gd_status <- map["gd_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return genders()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> genders {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: genders())
    }
}

//MARK:- Model of races
class races: NSObject, Mappable {
    
    var id : Int?
    var rc_name : String?
    var rc_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        rc_name <- map["rc_name"]
        rc_status <- map["rc_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return races()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> races {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: races())
    }
}

//MARK:- Model of industries
class industries: NSObject, Mappable {
    
    var id : Int?
    var in_name : String?
    var in_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        in_name <- map["in_name"]
        in_status <- map["in_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return industries()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> industries {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: industries())
    }
}

//MARK:- model of countries
class countries: NSObject, Mappable {
    
    var id : Int?
    var ct_name : String?
    var ct_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        ct_name <- map["ct_name"]
        ct_status <- map["ct_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return countries()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> countries {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: countries())
    }
}

//MARK:- model of states
class states: NSObject, Mappable {
    
    var id : Int?
    var st_name : String?
    var st_country_id : Int?
    var st_status : Int?
    
    required init?(map: Map) {}
    override init() {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        st_name <- map["st_name"]
        st_country_id <- map["st_country_id"]
        st_status <- map["st_status"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return states()
    }
    
    class func map(JSONObject: Any?, context: MapContext?) -> states {
        return Mapper(context: context).map(JSONObject: JSONObject, toObject: states())
    }
}

