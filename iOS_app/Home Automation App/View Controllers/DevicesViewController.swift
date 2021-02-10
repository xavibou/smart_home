//
//  DevicesViewController.swift
//  Home Automation App
//
//  Created by Xavier Bou on 4/7/20.
//  Copyright © 2020 Xavier Bou. All rights reserved.
//

import UIKit

class DevicesViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDevicesLabel: UILabel!
    
    var estimateWidth = 190.0
    var cellMarginSize = 16.0
    
    var http = HTTPCom()
    var devicesList = DevicesList(device: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegates
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Register cells
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        // SetupGrid view
        self.setupGridView()
        
        // Set up refresh control and update UI
        configureRefreshControl()
        updateDevices()
        
    }
    
    // Update the devices list
    func updateDevices() {
        // Send HTTP GET request
        http.getDevices() { (devices: DevicesList?, success: Bool?, error: Error?) -> () in
            
            if(!success!) {
                // TODO: Display error
                
            } else if (devices?.device?.count == 0){
                // TODO: No devices in the system
                self.devicesList = devices!
                self.noDevicesLabel.isHidden = false
                self.collectionView.reloadData()
                
            } else {
                // TODO: Load devices list
                print("IN VIEW CONTROLLER!")
                print(devices)
                self.devicesList = devices!
                self.noDevicesLabel.isHidden = true
                self.collectionView.reloadData()
            }
            // Dismiss the refresh control.
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // Set up cells grid
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    // set up listener for scroll update
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }
    
    // update devices when refreshing by scroll
    @objc func handleRefreshControl() {
        // Update your content…
        updateDevices()
    }
    
    // Update devices each time the VC is loaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateDevices()
    }
}

extension DevicesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.devicesList.device!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.setCell(device: self.devicesList.device![indexPath.row])
        //cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "newViewController") as! DeviceViewController
        vc.device = devicesList.device![indexPath.row]
        //vc.collectionView = self.collectionView
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension DevicesViewController: UICollectionViewDelegateFlowLayout {
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



