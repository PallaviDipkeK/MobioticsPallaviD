//
//  CardView.swift
//  MobioticsPallaviD
//
//  Created by Mac on 03/04/20.
//  Copyright © 2019 Mac. All rights reserved.
//
import UIKit
import Foundation
   @IBDesignable
    class CardView: UIView {
        @IBInspectable var cornerRadius: CGFloat = 2
        @IBInspectable var shadowOffsetWidth: Int = 0
        @IBInspectable var shadowOffsetHeight: Int = 3
        @IBInspectable var shadowColor: UIColor? = UIColor.black
        @IBInspectable var shadowOpacity: Float = 0.5
        
        override public func layoutSubviews() {
            layer.cornerRadius = cornerRadius
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            layer.masksToBounds = false
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = shadowPath.cgPath
        }
        
    }
