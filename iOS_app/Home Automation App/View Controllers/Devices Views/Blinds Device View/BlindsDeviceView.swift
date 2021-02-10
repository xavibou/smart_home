//
//  ItemCell.swift
//  GridViewExampleApp
//
//  Created by Chandimal, Sameera on 12/22/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit

class BlindsDeviceView: UICollectionViewCell {
    
    @IBOutlet weak var deviceTypeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var setBlindsUpButton: UIButton!
    @IBOutlet weak var setBlindsDownButton: UIButton!
    @IBOutlet weak var stopBlindsButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var device = Device()
    var http = HTTPCom()
    var deviceId = ""
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        // Cell layout
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        // Buttons layout
        deleteButton.layer.cornerRadius = 4
        deleteButton.layer.masksToBounds = true
        editButton.layer.cornerRadius = 4
        editButton.layer.masksToBounds = true
    }

    func setCell(device: Device) {
        self.device = device
        self.device._id = device._id!
        self.deviceTypeLabel.text = "Device Type: \(device.deviceType!)"
        self.roomLabel.text = "Room: \(device.room!)"
        if (device.state != nil){
            self.stateLabel.text = "State: \(device.state!)"
        } else {
            self.stateLabel.text = "State: not available"
        }
    }
    
    // Sends an action to set the blinds up
    @IBAction func setBlindsUpButtonClick(sender: UIButton) {
        // send action to API using the device ID
        print("SET BLINDS UP")
        http.sendAction(newState: "up", deviceId: self.device._id!) { ( success: Bool?, error: Error?) -> () in
            
            if(success!) {
                // TODO: Display error
                print("BLINDS WERE SET UP")
                
            } else {
                print("ERROR")
            }
        }
    }
    
    // Sends an action to set the blinds down
    @IBAction func setBlindsDownButtonClick(sender: UIButton) {
        // send action to API using the device ID
        print("SET BLINDS DOWN")
        http.sendAction(newState: "down", deviceId: self.device._id!) { ( success: Bool?, error: Error?) -> () in
            
            if(success!) {
                // TODO: Display error
                print("BLINDS WERE SET DOWN")
                
            } else {
                print("ERROR")
            }
        }
    }
    
    // Sends an action to set the blinds up
    @IBAction func stopBlindsButtonClick(sender: UIButton) {
        // send action to API using the device ID
        print("STOP BLINDS")
        http.sendAction(newState: "stop", deviceId: self.device._id!) { ( success: Bool?, error: Error?) -> () in
            
            if(success!) {
                // TODO: Display error
                print("BLINDS WERE STOPPED")
                
            } else {
                print("ERROR")
            }
        }
    }
    
    // Delete the device
    @IBAction func deleteButtonClick(sender: UIButton) {
        self.displayDeleteConfirmationAlert()
      }
    
    @IBAction func editButtonClick(sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("editDevice"), object: nil)
    }
    
    func deleteDevice()
    {
        // Send HTTP DELETE request
        http.deleteDevice(deviceId: device._id!) { (success: Bool?, error: Error?) -> () in
            
            if(!success!) {
                // Display error
                self.displayDeleteError()
                
            } else {
                // Device deleted, notify user and send notification back to VC to dismiss it
                UIApplication.shared.keyWindow?.rootViewController?.showToast(message: "Success!", font: UIFont(name: "Arial", size: 16.0)!)
                NotificationCenter.default.post(name: Notification.Name("dismissVC"), object: nil)
            }
        }
    }
    
    func displayDeleteConfirmationAlert() {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this device?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
             print("Ok button tapped")
             self.deleteDevice()
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
    
    func displayDeleteError() {
        // Declare Alert message
           let dialogMessage = UIAlertController(title: "Ops!", message: "Something wen't wrong, try again later!", preferredStyle: .alert)
           
           // Create OK button with action handler
           let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
           })
           
           //Add OK button to dialog message
           dialogMessage.addAction(ok)
           
           // Present dialog message to user
           UIApplication.shared.keyWindow?.rootViewController?.present(dialogMessage, animated: true, completion: nil)
    }
    
    
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }


