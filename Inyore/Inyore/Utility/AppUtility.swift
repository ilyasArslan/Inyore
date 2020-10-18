//
//  AppUtility.swift
//  e-EBM
//
//  Created by Arslan on 07/07/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SideMenu
//import PhoneNumberKit

class AppUtility: UIViewController, NVActivityIndicatorViewable
{
    static let shared = AppUtility()
    
//    let phoneNumberKit = PhoneNumberKit()
    
    //MARK:- FUNCTION FOR VALIDATIONS
    func isEmpty(_ thing : String? )->Bool
    {
        if (thing?.count == 0) {
            return true
        }
        return false;
    }
    
    func IsValidnName(_ username: String) -> Bool
    {
        let Username = "([A-Z][a-z]*)([\\s\\\'-][A-Z][a-z]*)*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", Username)
        return predicate.evaluate(with: username)
    }
    
    func IsValidEmail(_ email: String) -> Bool
    {
        let Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[a-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", Email)
        if(!isEmpty(email as String?) && predicate.evaluate(with: email))
        {
            return true;
        }
        else
        {
            return false;
        }
        
    }
    
    func IsValidPassword(_ password: String) -> Bool
    {
        let Password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", Password)
        return predicate.evaluate(with: password)
    }
    
//    func isValidPhoneNumber(strPhone:String) -> Bool
//    {
//        do {
//            _ = try phoneNumberKit.parse(strPhone)
//            return true
//        }
//        catch {
//            print("Generic parser error")
//            return false
//        }
//    }

    //MARK:- check internet connectivity
    func connected() -> Bool
    {
        let reachibility = Reachability.forInternetConnection()
        let networkStatus = reachibility?.currentReachabilityStatus()
        return networkStatus != NotReachable
    }
    
    //MARK:- Show Alert
    func displayAlert(title titleTxt:String, messageText msg:String, delegate controller:UIViewController) ->()
    {
        let alertController = UIAlertController(title: titleTxt, message: msg, preferredStyle: .alert)
        alertController.view.tintColor = #colorLiteral(red: 0.9568627451, green: 0.4549019608, blue: 0.1254901961, alpha: 1)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                controller.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- show Menu
    func showMenu(controller:UIViewController) ->(){
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = story.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
        let drawerWidth = self.view.frame.size.width - 100
        menuVC.setViewWidth = drawerWidth
        
        let menu = SideMenuNavigationController(rootViewController: menuVC)
        menu.view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9294117647, blue: 0.8980392157, alpha: 1)
        menu.leftSide = true
        menu.navigationBar.isHidden = true
        menu.statusBarEndAlpha = 0
        menu.alwaysAnimate = true
        menu.presentationStyle = SideMenuPresentationStyle.menuSlideIn
        menu.presentationStyle.presentingEndAlpha = 0.8
        menu.presentationStyle.onTopShadowOpacity = 0.5
        menu.presentationStyle.onTopShadowRadius = 5
        menu.presentationStyle.onTopShadowColor = .black
        menu.pushStyle = .popWhenPossible;
        menu.menuWidth = drawerWidth
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        SideMenuManager.default.rightMenuNavigationController = nil
        controller.present(menu, animated: true, completion: nil)
    }
    
    func hideMenu(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- show loader
    func showLoader(message: String)
    {
        let size = CGSize(width: 50.0, height: 50.0)
        startAnimating(size, message: message, type: .ballSpinFadeLoader, color: #colorLiteral(red: 0.9568627451, green: 0.4549019608, blue: 0.1254901961, alpha: 1), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), fadeInAnimation: nil)
    }
    
    func showLoaderWithoutMsg()
    {
        let size = CGSize(width: 50.0, height: 50.0)
        startAnimating(size, type: .ballSpinFadeLoader, color: .white, fadeInAnimation: nil)
    }
    
    func hideLoader()
    {
        stopAnimating()
    }
    
    func getCurrentMillis()->Int64
    {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

//MARK:- For round off value
extension Double
{
    func rounded(toPlaces places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//MARK:- Pop to specific ViewController
extension UINavigationController
{
    func popToViewController(ofClass: AnyClass, animated: Bool = true)
    {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) })
        {
            popToViewController(vc, animated: animated)
        }
    }
}

//MARK:- scroll to last item of collectionView
extension UICollectionView {
    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        let lastSection = numberOfSections - 1
        guard lastSection >= 0 else { return }
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
    
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
