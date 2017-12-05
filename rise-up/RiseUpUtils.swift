//
//  RiseUpUtils.swift
//  rise-up
//
//  Created by koingdev on 12/5/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct RiseUpUtils{
    
//    static func retrieveData(urlParam: String, tableParam: UITableView){
//        Alamofire.request("http://192.168.1.102/riseup/View/Android.php", method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let jsonArray = JSON(value)
//                for (_, json) in jsonArray{
//                    let title = json["title"].string!
//                    let url = json["url"].string!
//                    let image = json["image"].string!
//                    let author = json["author"].string!
//                    let date = json["date"].string!
//                    let data = RiseUp(title: title, url: url, image: image,
//                                      author: author, date: date)
//                    riseUpArr.append(data)
//                }
//                tableParam.reloadData()
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
//    }
    
}
