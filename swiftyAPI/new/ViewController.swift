//
//  ViewController.swift
//  new
//
//  Created by mac on 10/11/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

class ViewController: UIViewController, APIHelperDelegate {
  
    @IBOutlet var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //call api
        //with parameter
        let param : [String : AnyObject] = ["user_id":"2"  as AnyObject]
        let serverCall = APIHelper.sharedInstance
        //serverCall.requestWithUrlAndParameters(.POST,  urlString: "\(API_LOGIN)", parameters: param as [String : AnyObject], delegate: self, name: .APIHelperLogin)
        
        //without parameter
        serverCall.requestWithURL(.POST, urlString: "\(API_LOGIN)", delegate: self, name: .APIHelperVerify)
        
       /* Alamofire.request("http://api.androidhive.info/contacts/").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(responseData.result.value!)
               if let resData = swiftyJsonVar["contacts"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
            }
        }*/
        //SVProgressHUD.show(withStatus: "Processing...", maskType: SVProgressHUDMaskType.black)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func APIHelperSuccess(_ resposeObject: AnyObject, name: APIHelperName) {
        print(resposeObject)
    }
    
    func APIHelperFailed(_ errorObject: String, name: APIHelperName) {
        print(errorObject)
    }
    
}

