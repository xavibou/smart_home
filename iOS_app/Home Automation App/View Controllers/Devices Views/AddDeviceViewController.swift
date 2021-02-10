//
//  AddDeviceViewController.swift
//  Home Automation App
//
//  Created by Xavier Bou on 4/12/20.
//  Copyright © 2020 Xavier Bou. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {
    
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var deviceTypeTextField: UITextField!
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var receivingTopicTextField: UITextField!
    @IBOutlet weak var respondingTopicTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    var isEdit = false
    var http = HTTPCom()
    var device = Device()
    
    @IBOutlet weak var xibView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isEdit){
            addButton.isHidden = true
            saveButton.isHidden = false
        }
        
        // Set keybord dissmissal TapGestureRecognzer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    // Registers a device in the system
    @IBAction func registerDeviceButtonClick(sender: UIButton) {
        
        if (!self.checkTextFields()){
            return
        }
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to register this device?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
             print("Ok button tapped")
             self.registerDevice()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        UIApplication.shared.keyWindow?.rootViewController?.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.deviceNameTextField.resignFirstResponder()
        self.deviceTypeTextField.resignFirstResponder()
        self.roomTextField.resignFirstResponder()
        self.stateTextField.resignFirstResponder()
        self.receivingTopicTextField.resignFirstResponder()
        self.respondingTopicTextField.resignFirstResponder()
    }
    
    func registerDevice() {
        self.device.name = self.deviceNameTextField.text
        self.device.deviceType = self.deviceTypeTextField.text
        self.device.room = self.roomTextField.text
        self.device.state = self.stateTextField.text
        self.device.receivingTopic = self.receivingTopicTextField.text
        self.device.respondingTopic = self.respondingTopicTextField.text
        
        http.registerDevice(device: device) { ( success: Bool?, error: Error?) -> () in
            
            if(!success!) {
                // TODO: Display error
                
            } else {
                // Device registered, notify user dismiss VC
                //
                //self.showToast(message: "Success!", font: UIFont(name: "Arial", size: 16.0)!)
                DispatchQueue.main.async {
                    self.navigationController!.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func checkTextFields() -> Bool{
        
       if(self.deviceNameTextField.text == "" ||
            self.deviceTypeTextField.text == "" ||
            self.roomTextField.text == "" ||
            self.stateTextField.text == "" ||
            self.receivingTopicTextField.text == "" ||
            self.respondingTopicTextField.text == "") {
            
            self.showEmptyField()
            return false
        }
        return true
    }
    
    func showEmptyField() {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Empty field!", message: "There is at least one field empty!", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        
        // Present dialog message to user
        UIApplication.shared.keyWindow?.rootViewController?.present(dialogMessage, animated: true, completion: nil)
    }
    
}

//extension Bundle {
//
//    static func loadView<BlindsDeviceView>(fromNib name: String, withType type: BlindsDeviceView.Type) -> BlindsDeviceView {
//        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? BlindsDeviceView {
//            return view
//        }
//
//        fatalError("Could not load view with type " + String(describing: type))
//    }
//
//}


