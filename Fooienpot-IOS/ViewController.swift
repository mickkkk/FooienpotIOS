//
//  ViewController.swift
//  Fooienpot-IOS
//
//  Created by Fhict on 02/01/2018.
//  Copyright © 2018 Mick. All rights reserved.
//

import UIKit
import GooglePlacePicker

class ViewController: UIViewController {
    var tip1 = Tip(a: "0", d: "test", c: "test")
    let settingsVC = SettingsViewController()
    
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn15: UIButton!
    @IBOutlet weak var btnKitchen: UIButton!
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnBoth: UIButton!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
    
    @IBAction func btnPress5(_ sender: UIButton) {
        btn5.setTitleColor(.blue, for: .normal)
        btn10.setTitleColor(.white, for: .normal)
        btn15.setTitleColor(.white, for: .normal)
        tip1.setAmount(a: "500")
    }
    @IBAction func btnPress10(_ sender: UIButton) {
        btn5.setTitleColor(.white, for: .normal)
        btn10.setTitleColor(.blue, for: .normal)
        btn15.setTitleColor(.white, for: .normal)
        tip1.setAmount(a: "1000")
    }
    @IBAction func btnPress15(_ sender: UIButton) {
        btn5.setTitleColor(.white, for: .normal)
        btn10.setTitleColor(.white, for: .normal)
        btn15.setTitleColor(.blue, for: .normal)
        tip1.setAmount(a: "1500")
    }
    @IBAction func btnPressKitchen(_ sender: UIButton) {
        btnKitchen.setTitleColor(.blue, for: .normal)
        btnService.setTitleColor(.white, for: .normal)
        btnBoth.setTitleColor(.white, for: .normal)
        tip1.setDepartment(d: "kitchen")
    }
    @IBAction func btnPressService(_ sender: UIButton) {
        btnKitchen.setTitleColor(.white, for: .normal)
        btnService.setTitleColor(.blue, for: .normal)
        btnBoth.setTitleColor(.white, for: .normal)
        tip1.setDepartment(d: "Service")
    }
    @IBAction func btnPressBoth(_ sender: UIButton) {
        btnKitchen.setTitleColor(.white, for: .normal)
        btnService.setTitleColor(.white, for: .normal)
        btnBoth.setTitleColor(.blue, for: .normal)
        tip1.setDepartment(d: "Both")
    }
    
    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.nameLabel.text = place.name
                self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
            } else {
                self.nameLabel.text = "No place selected"
                self.addressLabel.text = ""
            }
        })
    }
    @IBAction func payStripe(_ sender: UIButton) {
        let comment = commentText.text!
        tip1.setComment(c: comment)
        
        TipService().tipPost(amount: tip1.getAmount(), department: tip1.getDepartment(), comment: tip1.getComment(), succes: { message in
            //self.show(message: self.tip1.getAmount() + "$ - to " + self.tip1.getDepartment())
        }) { error in
            self.showDialog(message: error)
        }
        let product = tip1.getDepartment()
        let price = tip1.getAmount()
        let priceInt = (price as NSString).integerValue
        let checkoutViewController = CheckoutViewController(product: product,
                                                            price: priceInt,
                                                            settings: self.settingsVC.settings)
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
    
    func show(message: String) {
        let controller = UIAlertController(title: "Thanks for the Tip!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    func showDialog(message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //dismiss keyboard when tapping outside the textview.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

