//
//  CachedDataLoader.swift
//  TopNews
//
//  Created by Ilya Maier on 31.05.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import Foundation
import UIKit

class CachedDataLoader {
    static let shared = CachedDataLoader()

    fileprivate var cache: Dictionary<String,Data> = [:]
    
    func loadImage(url:String, comletition:@escaping (_ url:String,_ image:UIImage?)-> ()) {
        if let data = self.cache[url] {
            let img = UIImage.init(data: data)
            comletition(url, img);
        } else {
            if let imgUrl = URL(string: url) {
                let task = URLSession.shared.dataTask(with: imgUrl )  { (data :Data?, response: URLResponse?, error: Error?) in
                    if let data = data {
                        let img = UIImage.init(data: data)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                            self.cache[url] = data
                            comletition(url, img);
                        })
                    } else {
                        DispatchQueue.main.async {
                            comletition(url, nil)
                        }
                    }
                }
                task.resume()
            } else {
                comletition(url, nil)
            }
        }
    }
    
    func loadData(url:String, comletition:@escaping (_ url:String,_ data :Data?)-> ()) {
        if let data = self.cache[url] {
            comletition(url, data);
        } else {
            if let dataUrl = URL(string: url) {
                let task = URLSession.shared.dataTask(with: dataUrl)  { (data :Data?, response: URLResponse?, error: Error?) in
                    if let data = data {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                            self.cache[url] = data
                            comletition(url, data);
                        })
                    } else {
                        DispatchQueue.main.async {
                            comletition(url, nil)
                        }
                    }
                }
                task.resume()
            } else {
                comletition(url, nil)
            }
        }
    }

}
