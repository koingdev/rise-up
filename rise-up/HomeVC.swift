//
//  ViewController.swift
//  rise-up
//
//  Created by koingdev on 12/4/17.
//  Copyright © 2017 koingdev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //default home title
    var screenTitle = Constant.DEFAULT_SCREEN_TITLE
    //array for storing article data
    var riseUpArr: [RiseUp] = []
    var urlPage = 1
    //indicator when loading table view
    var activityIndicatorView : UIActivityIndicatorView!
    //table view footer contains loading indicator
    var footerCell: UITableViewCell!
    var hasDataNextPage = true
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFeedback: UILabel!
    
    var refreshControl: UIRefreshControl!
    var isSwiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = screenTitle
        self.lblFeedback.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        //testing on iOS 9.0
        self.tableView.addSubview(refreshControl)
//        if #available(iOS 10.0, *) {
//            tableView.refreshControl = refreshControl
//        } else {
//            tableView.backgroundView = refreshControl
//        }
        
        //add footerCell to tableFooterView and hide it by default
        //And when user scroll to bottom, footerCell shows, but if data on next page not exist
        //it will hide
        footerCell = tableView.dequeueReusableCell(withIdentifier: "loading_next")
        self.tableView.tableFooterView = footerCell
        self.tableView.tableFooterView?.isHidden = true
        
        //to make side bar menu works
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 100
            btnMenu.target = self.revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        //set up loading indicator
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.tableView.backgroundView = activityIndicatorView
        //start loading indicator
        self.activityIndicatorView?.startAnimating()

        //loading data
        self.loadData(page: urlPage)
    }
    
    //pull to refresh data
    func refresh(_ refreshControl: UIRefreshControl) {
        activityIndicatorView?.startAnimating()
        //remove all current data, reload tableview
        self.riseUpArr.removeAll()
        self.tableView.reloadData()
        //set these 4 variable to default value
        self.urlPage = 1
        self.hasDataNextPage = true
        self.lblFeedback.isHidden = true
        self.tableView.tableFooterView?.isHidden = true
        //start fetching data and reload new tableview
        self.loadData(page: urlPage)
        //end refreshing
        self.refreshControl?.endRefreshing()
    }
    
    func loadData(page: Int){
        var fullUrl = ""
        //compare the screen title to generate each url of the screen
        switch self.screenTitle{
            case Constant.ANDROID_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.ANDROID_URL + String(page)
                break
            case Constant.API_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.API_URL + String(page)
                break
            case Constant.CMS_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.CMS_URL + String(page)
                break
            case Constant.CONCEPT_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.CONCEPT_URL + String(page)
                break
            case Constant.DB_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.DB_URL + String(page)
                break
            case Constant.IOS_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.IOS_URL + String(page)
                break
            case Constant.NEWS_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.NEWS_URL + String(page)
                break
            case Constant.TOOL_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.TOOL_URL + String(page)
                break
            case Constant.UIUX_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.UIUX_URL + String(page)
                break
            case Constant.WEB_SCREEN_TITLE:
                fullUrl = Constant.MAIN_URL + Constant.WEB_URL + String(page)
                break
            default:
                fullUrl = Constant.MAIN_URL + Constant.ANDROID_URL + String(page)
        }
        //request to the server with Alamofire and extract data withSwiftSOUP
        Alamofire.request(fullUrl, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):
                do{
                    let doc: Document = try SwiftSoup.parse(value)
                    let element = try doc.select("div#content_box")
                    let items = try element.select("div.post").array()
                    for item in items{
                        let title = try item.select("h2.title").text()
                        let url = try item.select("a").attr("href")
                        let image = try item.select("img").attr("src")
                        let date = try item.select("span.thetime").text()
                        let data = RiseUp(title: title, url: url, image: image, date: date)
                        //append data to an array
                        self.riseUpArr.append(data)
                    }
                    //reload the table view if data exists
                    self.tableView.reloadData()

                }catch Exception.Error(let type, let message){
                    self.activityIndicatorView.stopAnimating()
                }catch{
                    self.activityIndicatorView.stopAnimating()
                }
                
            case .failure(let error):
                if self.urlPage == 1 {
                    //show feed back
                    self.lblFeedback.isHidden = false
                    self.lblFeedback.text = Constant.FEEDBACK
                } else {
                    //when next page data not found, hide the footer indicator
                    self.tableView.tableFooterView?.isHidden = true
                    self.hasDataNextPage = false
                    print("No data found!!!")
                }

            }
            //stop animate the loading indicator
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    //when user click on each row, send the content url to ContentVC to open in WebView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "content" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let currentRowIndex = indexPath.row
                let currentUrl = self.riseUpArr[currentRowIndex].url
                let contentView = segue.destination as! ContentVC
                contentView.url = currentUrl!
            }
        }
    }
    
    //number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.riseUpArr.count
    }
    //load data into each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a resusable cell and case it to CategoryCell, then pass to cell variable
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RiseUpCell {
            let riseUp = self.riseUpArr[indexPath.row]
            //update the cell data
            cell.updateCell(content: riseUp)
            //styling the row layout
            cell.cardView.layer.masksToBounds = true
            cell.cardView.layer.cornerRadius = 20.0
            cell.cardView.layer.borderWidth = 1.3
            cell.cardView.layer.borderColor = UIColor(red: 99/255.0, green: 221/255.0, blue: 180/255.0, alpha: 1.0).cgColor
            return cell
        } else {
            return RiseUpCell()
        }
    }
    //reset selected cell color
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //scroll to bottom of tabe view, this function invoke
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.riseUpArr.count > 4 {
            //when scroll to cell index n-1 and if hasDataNextPage is true => do work
            if indexPath.row == self.riseUpArr.count - 1 {
                if hasDataNextPage {
                    urlPage += 1
                    self.loadData(page: urlPage)
                    //show the loading indicator at the footer of tableview
                    self.tableView.tableFooterView?.isHidden = false
                    print("loading page: \(urlPage)")
                    print("total array: \(self.riseUpArr.count)")
                }
            }
        }
    }
}
