//
//  LinkedInConstants.swift
//  LinkedInSignInExample
//
//  Created by John Codeos on 11/8/19.
//  Copyright © 2019 John Codeos. All rights reserved.
//

import Foundation


struct LinkedInConstants {
    
    static let CLIENT_ID = "77vnr2yvi1guid"
    static let CLIENT_SECRET = "ZmUPBveM78kC5DvR"
    static let REDIRECT_URI = "https://www.inyore.com/linkedin/login"
    static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
    
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}
