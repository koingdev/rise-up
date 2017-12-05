//
//  RiseUp.swift
//  rise-up
//
//  Created by koingdev on 12/5/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import Foundation

class RiseUp {
    private(set) public var title = ""
    private(set) public var url = ""
    private(set) public var image = ""
    private(set) public var author = ""
    private(set) public var date = ""
    
    init(title: String, url: String, image: String, author: String, date: String) {
        self.title = title
        self.url = url
        self.image = image
        self.author = author
        self.date = date
    }
    
    public func printData(){
        print(self.title)
        print(self.url)
        print(self.image)
        print(self.author)
        print(self.date)
    }
    
}
