//
//  Apputility.swift
//  MobioticsPallaviD
//
//  Created by Mac on 03/04/20.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

typealias CompletionHandler = (_ success: Bool, AnyObject?) -> Void


class AppUtility: NSObject {
    static let shareInstance = AppUtility()
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

}


    
