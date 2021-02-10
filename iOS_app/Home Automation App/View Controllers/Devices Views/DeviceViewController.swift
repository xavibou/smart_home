//
//  DeviceViewController.swift
//  Home Automation App
//
//  Created by Xavier Bou on 4/7/20.
//  Copyright © 2020 Xavier Bou. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deviceNameLabel: UILabel!
        
    var estimateWidth = 190.0
    var cellMarginSize = 16.0
    var numberOfCells = 1
    
    var http = HTTPCom()
    var device = Device()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegates
        self.collectionView.delegate = self
//
        self.collectionView.dataSource = self
        
        // Register cells
        self.collectionView.register(UINib(nibName: "BlindsDeviceView", bundle: nil), forCellWithReuseIdentifier: "BlindsDeviceView")
        
        // SetupGrid view
        self.setupGridView()
        
        // Set up refresh control and update UI
        configureRefreshControl()
        updateDevice()
        
        // Listen to notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissVC(notification:)), name: Notification.Name("dismissVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.editDevice(notification:)), name: Notification.Name("editDevice"), object: nil)
        
    }
    
    func updateDevice() {
        // Send HTTP GET request
        http.getDeviceById(deviceId: device._id!) { (device: Device?, success: Bool?, error: Error?) -> () in
            
            if(!success!) {
                // TODO: Display error
                
            } else if (device == nil){
                // TODO: No devices in the system
                
            } else {
                self.device = device!
                self.deviceNameLabel.text = device?.name
                self.collectionView.reloadData()
            }
            // Dismiss the refresh control.
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
                
               // self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    @objc func dismissVC(notification: NSNotification) {
        DispatchQueue.main.async {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    @objc func editDevice(notification: NSNotification) {
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "EditDeviceVC") as! EditDeviceViewController
            vc.device = self.device
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        // Update your content…
        updateDevice()
    }
    
    // Update devices each time the VC is loaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateDevice()
    }
}

extension DeviceViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlindsDeviceView", for: indexPath) as! BlindsDeviceView
        cell.setCell(device: self.device)
        
        return cell
    }
}

extension DeviceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}



