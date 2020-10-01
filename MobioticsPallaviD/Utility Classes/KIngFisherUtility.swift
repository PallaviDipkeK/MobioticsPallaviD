//
//  KIngFisherUtility.swift
//  MobioticsPallaviD
//
//  Created by Mac on 03/04/20.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import Kingfisher

class Utilies {
    
    class func setImage(onImageView image:UIImageView,withImageUrl imageUrl:String?,placeHolderImage: UIImage) {
        
        if let imgurl = imageUrl{
            //image.kf.indicatorType = IndicatorType.activity
            
            image.kf.setImage(with: URL(string: imgurl), placeholder: placeHolderImage, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
            })
            
        } else{
            image.image = placeHolderImage
        }
    }
}
