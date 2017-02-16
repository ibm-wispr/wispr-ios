//
//  ViewController.swift
//  WISPr
//
//  Created by Brian Cheng on 2/7/17.
//  Copyright © 2017 Brian Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func doLogin(_ sender: Any) {
        let post_data: NSDictionary = NSMutableDictionary()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let login_url = appDelegate.apiURL + "/authentication/login"
        
        dismissKeyboard()
        post_data.setValue(username.text!, forKey: "username")
        post_data.setValue(password.text!, forKey: "password")
        
        let url:URL = URL(string: login_url)!
        let session = URLSession.shared
        var jwt = ""
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        var paramString = ""
        
        
        for (key, value) in post_data
        {
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String:Any] {
                   if let jsonDataArray = json["data"] as?[Any]{
                        if let jsonData = jsonDataArray[0] as? [String:Any]{
                            jwt = jsonData["token"] as! String
                        }
                    }
                }
            } catch let err{
                print(err.localizedDescription)
            }
            if (!jwt.isEmpty){
                //we have a token, show the mail.
                let listEmailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ListEmail") as! ListEmailTableViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.jwt_token=jwt
                var nav1 = UINavigationController()
                nav1.viewControllers = [listEmailViewController]
                DispatchQueue.main.async(){
                    //code
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = nav1;

                }
                
                                //UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
            }else{
                //no token.  show an error login message
            }
            
        })
        
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}

