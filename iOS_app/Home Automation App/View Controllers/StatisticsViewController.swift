//
//  StatisticsViewController.swift
//  Home Automation App
//
//  Created by Xavier Bou on 4/7/20.
//  Copyright © 2020 Xavier Bou. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    
    
    var estimateWidth = 190.0
    var cellMarginSize = 16.0
    var numberOfCells = 3
    
    var http = HTTPCom()
    var actionsList = ActionsList(action: [])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        // Setu up refresh control and update UI
        configureRefreshControl()
        updateCharts()
    }
    
    
    func updateCharts() {
        // TODO: Show loading view
        
        // Send HTTP GET request
        http.getActions() { (actions: ActionsList?, success: Bool?, error: Error?) -> () in
            
            if(!success!) {
                // TODO: Display error
                
            } else if (actions?.action?.count == 0){
                // TODO: No devices in the system
                print("IN VIEW CONTROLLER BUT EMPTY ARRAY!")
                print(actions)
            } else {
                // TODO: Load devices list
                print("IN VIEW CONTROLLER!")
                print(actions)
                self.actionsList = actions!
                self.setupBarChart()
                //self.collectionView.reloadData()

        
            }
            // Dismiss the refresh control.
            DispatchQueue.main.async {
//                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func setupBarChart() {
        barChart.drawGridBackgroundEnabled = false
        barChart.setScaleEnabled(true)
        
        // X axis configurations
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.granularity = 1
        barChart.xAxis.drawAxisLineEnabled = true
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 15.0)
        barChart.xAxis.labelTextColor = UIColor.black
        barChart.xAxis.labelPosition = .bottom

        // Right axis configurations
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false

        // Other configurations
        barChart.highlightPerDragEnabled = false
        barChart.chartDescription?.text = ""
        barChart.legend.enabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.scaleYEnabled = false

        barChart.drawMarkers = true
        barChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        
        let entry1 = BarChartDataEntry(x: 1.0, y: Double(1))
        let entry2 = BarChartDataEntry(x: 2.0, y: Double(2))
        let entry3 = BarChartDataEntry(x: 3.0, y: Double(3))
        let dataSet = BarChartDataSet(entries: [entry1, entry2, entry3], label: "Widgets Type")
        let data = BarChartData(dataSets: [dataSet])
        self.barChart.data = data
        self.barChart.chartDescription?.text = "Number of Widgets by Type"
        
        //All other additions to this function will go here
        
        //This must stay at end of function
        self.barChart.notifyDataSetChanged()
        
    }
    
    @IBAction func renderCharts() {
        updateCharts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            //self.collectionView.reloadData()
        }
    }
    

    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.addTarget(self, action:
//            #selector(handleRefreshControl),
//                                                 for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        // Update the content
        updateCharts()
    }
    
}




