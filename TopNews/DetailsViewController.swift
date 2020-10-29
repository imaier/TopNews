//
//  DetailsViewController.swift
//  TopNews
//
//  Created by Ilya Maier on 03.06.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desriptionLabel: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    var news: News? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let webConfiguration = WKWebViewConfiguration()
        //webView = WKWebView(frame: .zero, configuration: webConfiguration)
        //wkWebView.uiDelegate = self
        //view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let rec = self.news {
            //let myURL = URL(string:"https://www.apple.com")
            let myURL = URL(string:rec.url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
            
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
