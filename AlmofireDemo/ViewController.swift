//
//  ViewController.swift
//  AlmofireDemo
//
//  Created by Neha Penkalkar on 25/04/21.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    @IBOutlet weak var cityTV: UITableView!
    
    var stateDict = NSDictionary()
    var cityNameArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        alamoFirePostExample()
    }
    
    func alamoFirePostExample(){
        let param = ["request":"city_listing","device_type":"ios","country":"india"]
        AF.request("https://www.kalyanmobile.com/apiv1_staging/city_listing.php", method: .post, parameters: param).responseJSON { (resp) in
            if let dict = resp.value as? NSDictionary{
                if let respCode = dict.value(forKey: "responseCode") as? String, let respMsg = dict.value(forKey: "responseMessage") as? String{
                    if respCode == "success"{
                        let dataResp = resp.value as! NSDictionary
                        self.stateDict = dataResp.value(forKey: "city_array") as! NSDictionary
                        print("Success")
                        self.cityTV.reloadData()
                    }else{
                        print(respMsg)
                    }
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return stateDict.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "CustomHeader") as! CustomHeader
        header.CountryName.text = "\(stateDict.allKeys[section])"
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = stateDict.allKeys as! [String]
        let arr1 = arr[section]
        cityNameArr = stateDict.value(forKey: "\(arr1)") as! [String]
        return cityNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
}
