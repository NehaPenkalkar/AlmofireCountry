//
//  ViewController.swift
//  AlmofireDemo
//
//  Created by Neha Penkalkar on 25/04/21.
//

import UIKit
import Alamofire
import Lottie

class ViewController: UIViewController {
    @IBOutlet weak var cityTV: UITableView!
    
    @IBOutlet var errView: UIView!
    @IBOutlet weak var errLbl: UILabel!
    
    var stateDict = NSDictionary()
    var cityNameArr = [String]()
    
    @IBOutlet weak var animView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        alamoFirePostExample()
    }
    
    func showErr(msg: String){
        self.errLbl.text = msg
        self.cityTV.backgroundView = self.errView
        animView.loopMode = .loop
        animView.play()
    }
    
    @IBAction func retryBtn(_ sender: UIButton) {
        alamoFirePostExample()
    }
    
    func alamoFirePostExample(){
        if Connectivity.isConnectedToInternet(){
            print("Connected")
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
                            self.showErr(msg: respMsg)
                            print(respMsg)
                        }
                    }
                }
            }
        }else{
            showErr(msg: "Internet connection not available, Please check your connection and try again.")
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTVC") as! CustomTVC
        let arr = stateDict.allKeys as! [String]
        let arr1 = arr[indexPath.section]
        cityNameArr = stateDict.value(forKey: "\(arr1)") as! [String]
        cell.cityLbl.text = "\(cityNameArr[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
