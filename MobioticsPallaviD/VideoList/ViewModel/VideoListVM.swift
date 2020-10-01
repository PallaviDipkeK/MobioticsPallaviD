//
//  VideoListVM.swift
//  MobioticsPallaviD
//
//  Created by Administrator on 03/04/20.
//  Copyright © 2020 Administrator. All rights reserved.
//

import Foundation
import Alamofire

class VideoListVM {
    static let shared = VideoListVM()
    
    private init(){
        
    }
    
    func getData(completionHandler: @escaping CompletionHandler) {
        let url = "https://interview-e18de.firebaseio.com/media.json?print=pretty"
        Alamofire.request(url, method: .get, parameters: nil).responseJSON
            {
                response in
                switch response.response?.statusCode {
                case 200:
                    if let jsonResponse = response.data {
                        print(jsonResponse)
                        completionHandler(true, jsonResponse as AnyObject)
                        return
                    }else {
                        completionHandler(false, nil)
                        return
                    }
                    
                default:
                    completionHandler(false, nil)
                    return
                }
        }
    }
}
