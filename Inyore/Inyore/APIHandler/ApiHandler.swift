//
//  ApiHandler.swift
//  UnisLinker
//
//  Created by BILAL on 16/03/2019.
//  Copyright © 2019 Ranksol. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

private let SharedInstance = APIHandler()

enum Endpoint : String {
    
    //MARK: User
    case login                         = "api/user/login"
    case register                      = "api/user/register"
    case forgetPassword                = "api/user/forgot-password"
    case socialLogin                   = "api/user/detail"
    case appleLogin                    = "api/user/apple/login"
    case logout                        = "api/user/logout"
    
    //MARK:- Home
    case home                          = "api/get/home?api_token="
    
    //MARK:- explore communities
    case exploreCommunities            = "api/get/communities?api_token="
    
    //MARK:- speak truth
    case speakTruth                    = "api/get/speak-your-truth?api_token="
    
    //MARK:- sent invitation
    case sentInvitation                = "api/post/send-invite"
    
    //MARK:- create truth Communities
    case createTruthCommunity          = "api/get/truthcreate/communities?api_token="
    
    //MARK:- create Truth
    case createTruth                   = "api/post/save-truth"
    
    //MARK:- be Heard
    case beHeard                       = "api/get/be-heard?api_token="
    case beHeardSendData               = "api/post/save/be-heard"
    
    //MARK:- case praise an Article
    case praiseAnArticle                = "api/post/praise"
    
    //MARK:- single community
    case singleCommunity                = "api/get/single-community?community_id="
    case ediCommunity                   = "api/post/truthcreate/communities"
    case deleteCommunity                = "api/post/article/delete"
    
    //MARK:- follow and Unfollow
    case follow                         = "api/post/follow-community"
    
    //MARK:- contact
    case contact                        = "api/post/submit-contact"
    
    //MARK:- Notification
    case notification                   = "api/get/notifications?api_token="
    
    //MARK:- single Truth
    case singleTruth                    = "api/get/single-truth?truth_id="
    
    //MARK:- report
    case getReport                      = "api/get/report/options?api_token="
    
}


class APIHandler: NSObject {
    
    var baseApiPath:String!
    var myUser: [User]? {didSet {}}
    
    class var sharedInstance : APIHandler {
        return SharedInstance
    }
    
    override init() {
        
        self.baseApiPath = "https://www.inyore.com/"
    }
    
    //MARK:- user login
    func userLogin(params: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.login.rawValue)"
        print("FinalUrl: ", finalURL)
        
        Alamofire.request(finalURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- user Register
    func userRegister(email: String, password: String, completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.register.rawValue)"
        print("FinalUrl: ", finalURL)
        
        let params = ["email": email, "password": password]
        
        Alamofire.request(finalURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {
                
//                let str = String(decoding: response.result.value!, as: UTF8.self)
//                print("String: ", str)
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- user logout
    func userLogout(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let uid = self.myUser![0].id!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.logout.rawValue)"
        print("FinalUrl: ", finalURL)
        print(uid)
        let param = ["uid": uid]
        
        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess{
                
                let str = String(decoding: response.result.value!, as: UTF8.self)
                print("String: ", str)
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }

    //MARK:- forget password
    func forgetPassword(param: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.forgetPassword.rawValue)"
        print("FinalUrl: ", finalURL)

        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- Home
    func home(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.home.rawValue)\(api_token)"
        print("FinalUrl: ", finalURL)
        
        let params = ["api_token": api_token]
                
        Alamofire.request(finalURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- explore Communities
    func exploreCommunities(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.exploreCommunities.rawValue)\(api_token)"
        print("FinalUrl: ", finalURL)
        
        let params = ["api_token": api_token]
                
        Alamofire.request(finalURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- explore Communities
    func speakTruth(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.speakTruth.rawValue)\(api_token)"
        print("FinalUrl: ", finalURL)
        
        let params = ["api_token": api_token]
                
        Alamofire.request(finalURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- sent invitation by link
    func sentInvitation(email: String, completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.sentInvitation.rawValue)"
        print("FinalUrl: ", finalURL)
        
        let params = ["api_token": api_token, "email": email]
        
        Alamofire.request(finalURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- create truth communities
    func createTruthCommunities(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.createTruthCommunity.rawValue)\(api_token)"
        print("FinalUrl: ", finalURL)
        
        let params = ["api_token": api_token]
        
        Alamofire.request(finalURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- create Truth
    func createTruthWithImage(image: UIImage, param: [String : String], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.createTruth.rawValue)"
        print("Final Url: ", finalURL)
        
        print("Image: ", image)
        print("Params: ", param)
                
        let img = image
        let imgData : Data = img.jpegData(compressionQuality: 0.5)!
        let currentTime = AppUtility.shared.getCurrentMillis()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData, withName: "community_banner_image",fileName: "\(currentTime)swift_file.jpg", mimeType: "image/jpg")
            
            for (key, value) in param {
                
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },
                         to: finalURL, headers: nil)
        { (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    print(response.result)
                    if response.result.isSuccess
                    {

                        do {
                            let json = response.result.value as! NSDictionary
                            AppUtility.shared.hideLoader()
                            completionHandler(true, json)

                        }
                    }
                    else{
                        AppUtility.shared.hideLoader()
                        completionHandler(false, nil)
                    }
                }

            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func createTruthWithOutImage(param: [String : String], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.createTruth.rawValue)"
        print("Final Url: ", finalURL)
        
        print("Params: ", param)
        
        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- edit community
    func editTruthCommunities(param: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.ediCommunity.rawValue)"
        print("FinalUrl: ", finalURL)
                
        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- be Heard
    func beHeard(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.beHeard.rawValue)\(api_token)"
        print("FinalUrl: ", finalURL)
        
        let params = ["api_token": api_token]
        
        Alamofire.request(finalURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- br Heard send data
    func beHeardSendData(param: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.beHeardSendData.rawValue)"
        print("FinalUrl: ", finalURL)
        
        print("params: ", param)
        
        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)
                    
                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- praise
    func praiseAnArticle(param: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        //AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.praiseAnArticle.rawValue)"
        print("FinalUrl: ", finalURL)

        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    //AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    //AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                //AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- single Community
    func singleCommunity(communityId: String, api_token: String, completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.singleCommunity.rawValue)\(communityId)&api_token=\(api_token)"
        print("FinalUrl: ", finalURL)

        Alamofire.request(finalURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    func deleteCommunity(param: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.deleteCommunity.rawValue)"
        print("FinalUrl: ", finalURL)

        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- follow/unfollow community
    func followCommunity(param: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        //AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.follow.rawValue)"
        print("FinalUrl: ", finalURL)

        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    //AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    //AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                //AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }

    //MARK:- contact
    func contact(param: [String : Any], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.contact.rawValue)"
        print("FinalUrl: ", finalURL)

        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- notification
    func notification(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.notification.rawValue)\(api_token)"
        print("FinalUrl: ", finalURL)
        
        Alamofire.request(finalURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- socialLogin
    func linkedInLogin(param: [String : String], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.socialLogin.rawValue)"
        print("FinalUrl: ", finalURL)
        
        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {
                let str = String(decoding: response.result.value!, as: UTF8.self)
                print("String: ", str)

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- apple Login
    func appleLogin(param: [String : String], completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.appleLogin.rawValue)"
        print("FinalUrl: ", finalURL)
        
        Alamofire.request(finalURL, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {
                let str = String(decoding: response.result.value!, as: UTF8.self)
                print("String: ", str)

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- single Truth
    func singleTruth(truthId: String, completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
//        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.singleTruth.rawValue)\(truthId)&api_token=\(api_token)"
        print("FinalUrl: ", finalURL)
        
        Alamofire.request(finalURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
//                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
//                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
//                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK:- get report
    func getReport(completionHandler : @escaping( _ result: Bool,  _ responseObject: NSDictionary?) -> Void){
        
        AppUtility.shared.showLoader(message: "Please wait...")
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let finalURL = "\(self.baseApiPath!)\(Endpoint.getReport.rawValue)\(api_token)"
        print("FinalUrl: ", finalURL)
        
        Alamofire.request(finalURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess
            {

                do {

                    let json = try JSONSerialization.jsonObject(with: response.result.value!, options: .mutableContainers)
                    let dict = json as? NSDictionary
                    AppUtility.shared.hideLoader()
                    completionHandler(true, dict)

                } catch {
                    AppUtility.shared.hideLoader()
                    completionHandler(false, nil)
                }
            }
            else
            {
                AppUtility.shared.hideLoader()
                completionHandler(false, nil)
            }
        }
    }
    
}
