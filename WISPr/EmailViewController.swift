//
//  EmailViewController.swift
//  WISPr
//
//  Created by Brian Cheng on 2/9/17.
//  Copyright © 2017 Brian Cheng. All rights reserved.
//

import UIKit



class EmailViewController: UIViewController {

    var messageId = ""
    var from = ""
    var subject = ""
    @IBOutlet weak var fromField: UILabel!
    @IBOutlet weak var bodyField: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromField.text = from
        self.title = subject
        getjson()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getjson() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let url:URL = URL(string: appDelegate.apiURL + "/messages/" + self.messageId )!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.setValue(appDelegate.jwt_token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String:Any] {
                    print(json)
                    if let jsonDataArray = json["data"] as?[[String:Any]]{
                        var emailData = jsonDataArray[0]["bodies"] as? [[String:Any]]
                        var emailBody = (emailData?[1]["body"])! as! [String:Any]
                        guard let htmlData = emailBody["text"] else {
                            self.bodyField.loadHTMLString("No content", baseURL: nil)
                            return
                        }
                        self.bodyField.loadHTMLString(htmlData as! String, baseURL: nil)
                    }
                }
            } catch let err{
                print(err.localizedDescription)
            }
            
        })
        
        task.resume()
    }

}
