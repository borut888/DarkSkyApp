 //
//  HelperClass.swift
//  DarkSkyApp
//
//  Created by Borut on 18/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

 import Foundation
 import UIKit
 import CoreLocation
 import Hue
 
 extension UIView {
    func setGradientBackground(firstColor: UIColor, secondColor: UIColor)  {
        let myGradient = [firstColor, secondColor].gradient() { gradient in
            gradient.locations = [0.6, 0.0]
            gradient.frame = self.bounds
            return gradient
        }
        layer.insertSublayer(myGradient, at: 0)
    }
 }
 
 func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
        guard let placemark = placemarks?.first, error == nil else {
            completion(nil, error)
            return
        }
        completion(placemark, nil)
    }
 }
 extension UITextField{
//    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
 }

 //let gradientLayer = CAGradientLayer()
 //        gradientLayer.frame = bounds
 //        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
 //        gradientLayer.locations = [0.6, 0.0]
 //        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
 //        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
 //        layer.insertSublayer(gradientLayer, at: 0)
