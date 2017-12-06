//
//  RiseUp.swift
//  rise-up
//
//  Created by koingdev on 12/5/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import Foundation

struct RiseUp {
    private(set) public var title: String?
    private(set) public var url: String?
    private(set) public var image: String?
    private(set) public var author: String?
    private(set) public var date: String?
    
    public init(title: String, url: String, image: String, author: String, date: String) {
        self.title = title
        self.url = url
        self.image = image
        self.author = author
        self.date = date
    }
    
}
