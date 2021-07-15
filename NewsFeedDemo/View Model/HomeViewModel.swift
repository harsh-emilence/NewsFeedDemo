//
//  HomeViewModel.swift
//  NewsFeedDemo
//
//  Created by Zimble on 14/07/21.
//

import Foundation
import UIKit

class HomeViewModel : NSObject {

    var modelData : Bindable<[ArticleModel]> = .init([])
    var offset : Int = 1
    var shouldLoadMore : Bool = false
    func getNewsFeed(pageIndex : Int = 1) {
        var userDefaults = UserDefaults.standard
        if pageIndex == 1 {
       
        
        if userDefaults.bool(forKey: "saved"){
            let decoded  = userDefaults.data(forKey: "news")
            let decodedNews = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [ArticleModel]
            modelData.value = decodedNews
           
        }
        }
        
        let url = URL(string: "https://newsapi.org/v2/everything?q=covid19&pageSize=10&page=\(pageIndex)&apiKey=5bfef52ca2af452f90068f91127dd082")
        NewsModel.getData(url: url!) { news in
            self.offset = pageIndex
           
                if news.count == 0{
                    self.shouldLoadMore = true
                }
                if self.offset == 1{
                    self.modelData.value = news
                }else{
                    self.modelData.value?.append(contentsOf: news)
                }
               
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.modelData.value!)
                userDefaults.set(encodedData, forKey: "news")
                userDefaults.synchronize()
                userDefaults.setValue(true, forKey: "saved")
               
        }
    }
    
    
}
