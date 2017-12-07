//
//  RiseUpCell.swift
//  rise-up
//
//  Created by koingdev on 12/5/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RiseUpCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    func updateCell(content: RiseUp){
        self.lblTitle.text = content.title!
        self.lblDate.text = content.date!
        Alamofire.request(content.image!).responseImage { response in
            if let image = response.result.value {
                self.imgImage.image = image
            }
        }
    }

}
