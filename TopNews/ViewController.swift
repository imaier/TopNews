//
//  ViewController.swift
//  TopNews
//
//  Created by Ilya Maier on 20.05.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate, UICollectionViewDataSource,  UICollectionViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collecionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var substrateTableView: UIView!
    @IBOutlet weak var substrateCollectionView: UIView!
    
    var totalResults = 0
    
    var newsArray = [News]()
    var filteredArray = [News]()
    
    var filter = FilterData();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeView(self)
        self.applyFilterAndReloadData()
        
        //tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 44     
    }
    
    func applyFilterAndReloadData(_ pageNum:Int = 0) {
       //API key is: e85917ff05654dc3bcb04e750ac9cbf0
        var params = ["apiKey":"e85917ff05654dc3bcb04e750ac9cbf0"];
        totalResults = 0
        params["country"] = FilterData.countries()[filter.country];
        if filter.category != noFilterIndex {
            params["category"] = FilterData.categories()[filter.category];
        }
        if !filter.Keywords.isEmpty {
            params["q"] = filter.Keywords;
        }
        params["pageSize"] = String(filter.pageSize);
        
        if pageNum > 0 {
            params["page"] = String(pageNum);
        } else {
            params["page"] = String(1);
        }
        
        AF.request("https://newsapi.org/v2/top-headlines", parameters: params)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let articles = json["articles"]
                self.totalResults = json["totalResults"].intValue
                if articles.type == .array {
                    let newsArray = articles.arrayValue.map { (jsonNews) -> News in
                        return News(urlToImage: jsonNews["urlToImage"].stringValue,
                                    title: jsonNews["title"].stringValue,
                                    url: jsonNews["url"].stringValue,
                                    description: jsonNews["description"].stringValue,
                                    author: jsonNews["author"].stringValue,
                                    publishedAt: jsonNews["publishedAt"].stringValue);
                    }
                     
                    if pageNum > 0 {
                        self.newsArray.append(contentsOf: newsArray)
                    } else {
                        self.newsArray.removeAll()
                        self.newsArray = newsArray
                    }
                    DispatchQueue.main.async {
                        self.applyFilter()
                    }
                }
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
            
            //print(response.debugDescription)
            //print(String(data: response.data!, encoding: .utf8))
        }
    }
    func applyFilter() {
        if let txt = searchBar.text {
            if txt.isEmpty {
                filteredArray = newsArray
            } else {
                filteredArray.removeAll()
                newsArray.forEach { (news) in
                    print(news.title)
                    if news.title.contains(subString: txt, options: .caseInsensitive) {
                        filteredArray.append(news);
                    }
                }
            }
        } else {
            filteredArray = newsArray
        }
        if !substrateTableView.isHidden {
            self.tableView.reloadData()
        } else {
            self.collecionView.reloadData()
        }
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
/*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128;
    }*/
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellCustomIdentifier", for: indexPath)
        let newsCell = cell as! NewsCellTableViewCell

        if (indexPath.row == self.filteredArray.count - 1) && self.newsArray.count < self.totalResults {
            //load next page
            let pageNum = self.newsArray.count / self.filter.pageSize;
            DispatchQueue.global().async {
                self.applyFilterAndReloadData(pageNum+1);
            }
        }
        
        
        let news = self.filteredArray[indexPath.row]
        // Configure the cell’s contents.
        newsCell.titleLabel.text = news.title
        newsCell.descriptionLabel.text = news.description
        newsCell.imageUrl =  news.urlToImage
        newsCell.newsImageView.image = nil
        newsCell.newsImageView.frame = CGRect(x:0, y:0, width:120, height:60);//  size.width = 120;
        newsCell.heightMin.constant = 60;
        newsCell.activityIndicator.startAnimating()
        newsCell.activityIndicator.isHidden = false
        newsCell.activityIndicator.hidesWhenStopped = true
        //newsCell.needsUpdateConstraints()

        //newsCell.setNeedsUpdateConstraints()
        //newsCell.setNeedsLayout()
        //tableView.layoutIfNeeded()
        
        
        CachedDataLoader.shared.loadImage(url: newsCell.imageUrl) { (url:String, image: UIImage?) in
            if url == newsCell.imageUrl {
                if let img = image {
                    let ratio = img.size.width/img.size.height;
                    let maxW = 120/ratio;
                    let maxH = CGFloat(60.0);
                    newsCell.heightMin.constant = min(maxW, maxH);
                    newsCell.newsImageView.image = img
                } else {
                    newsCell.heightMin.constant = 60;
                }
                
                newsCell.activityIndicator.stopAnimating();
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: "accessorySeque", sender: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < self.newsArray.count {
            let news = self.filteredArray[indexPath.row]
            self.performSegue(withIdentifier: "detailsSegue", sender: news)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let detailsViewController = (segue.destination as! DetailsViewController) as DetailsViewController? {
                detailsViewController.news = sender as? News
            }
        } else if segue.identifier == "filterSeque" {
            if let filterViewController = (segue.destination as! FilterViewController) as FilterViewController? {
                //detailsViewController.news = sender as? JSON
                filterViewController.filterData = filter;
                filterViewController.delegate = self;
            }
        }
    }
    
    // MARK: - FilterViewControllerDelegate
    func filterChanged(_ filter: FilterData) {
        self.filter = filter
        applyFilterAndReloadData()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilter()
    }
    
    @IBAction func changeView(_ sender: Any) {
        substrateCollectionView.isHidden = !substrateCollectionView.isHidden
        substrateTableView.isHidden = !substrateCollectionView.isHidden
        self.applyFilter()
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCellCollectionViewIdentifier", for: indexPath)
        let newsCell = cell as! NewsCollectionViewCell
        
        if (indexPath.row == self.filteredArray.count - 1) && self.newsArray.count < self.totalResults {
            //load next page
            let pageNum = self.newsArray.count / self.filter.pageSize;
            DispatchQueue.global().async {
                self.applyFilterAndReloadData(pageNum+1);
            }
        }
        
        let news = self.filteredArray[indexPath.row]
        // Configure the cell’s contents.
        newsCell.titleLabel.text = news.title
        newsCell.imageUrl =  news.urlToImage
        newsCell.newsImageView.image = nil
        newsCell.activityIndicator.startAnimating()
        newsCell.activityIndicator.isHidden = false
        newsCell.activityIndicator.hidesWhenStopped = true

        
        CachedDataLoader.shared.loadImage(url: newsCell.imageUrl) { (url:String, image: UIImage?) in
            if url == newsCell.imageUrl {
                if let img = image {
                    newsCell.newsImageView.image = img
                }
                
                newsCell.activityIndicator.stopAnimating();
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.newsArray.count {
            let news = self.filteredArray[indexPath.row]
            self.performSegue(withIdentifier: "detailsSegue", sender: news)
        }
    }
}

