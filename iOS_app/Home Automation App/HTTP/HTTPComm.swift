//
//  HTTPComm.swift
//  Home Automation App
//
//  Created by Xavier Bou on 4/7/20.
//  Copyright © 2020 Xavier Bou. All rights reserved.
//

import Foundation


struct Customer: Codable {
    let object: String
    let id: String
    let email: String
    let metadata: Metadata
}

struct Metadata: Codable {
    let link_id: String
    let buy_count: Int
}

class HTTPCom {
    
    // Gets an array of devices from the system
    func getDevices(completion: @escaping (_ devicesList: DevicesList?, _ success: Bool?, _ error: Error?) -> ()){
        var devicesList = DevicesList.init(device: []);
        
        let url = URL(string: "https://pda-home-automation.herokuapp.com/api/device/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    completion(devicesList, false, ("Failed to get data from url:", err) as? Error)
                }
                
                guard let data = data else { return }
                devicesList = self.parseDevices(data: data)
                
                if ((devicesList.device?.isEmpty) == nil) {
                    completion(devicesList, false, "Data object empty" as? Error)
                } else {
                    completion(devicesList, true, nil)
                }
            }
        }.resume()
    }
    
    // Gets a device specified by a unique identifier
    func getDeviceById(deviceId: String, completion: @escaping (_ device: Device?, _ success: Bool?, _ error: Error?) -> ()){
        var device = Device();
        
        let url = URL(string: "https://pda-home-automation.herokuapp.com/api/device/" + deviceId)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    completion(nil, false, ("Failed to get data from url:", err) as? Error)
                }
                
                guard let data = data else { return }
                device = self.parseDevice(data: data)
                
                if (device._id == nil) {
                    completion(nil, false, "Data object empty" as? Error)
                } else {
                    completion(device, true, nil)
                }
            }
        }.resume()
    }
    
    // Deletes a device specified by a unique identifier
    func deleteDevice(deviceId: String, completion: @escaping (_ success: Bool?, _ error: Error?) -> ()){
        var device = Device();
        
        guard let url = URL(string: "https://pda-home-automation.herokuapp.com/api/device/\(deviceId)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async{
                
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                        print("error", error ?? "Unknown error")
                        completion(false, error)
                        return
                }
                
                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    
                    completion(false, "statusCode should be 2xx, but is \(response.statusCode)" as? Error)
                    return
                }
                print("ºdevice deleted successfully: \(url)")
                completion(true, nil)
            }
            
        }.resume()
        
    }
    
    // Gets an array of actions logged within the system
    func getActions(completion: @escaping (_ actionsList: ActionsList?, _ success: Bool?, _ error: Error?) -> ()){
        var actionsList = ActionsList.init(action: []);
        
        let url = URL(string: "https://pda-home-automation.herokuapp.com/api/action/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    completion(actionsList, false, ("Failed to get data from url:", err) as? Error)
                }
                
                guard let data = data else { return }
                actionsList = self.parseActions(data: data)
                
                if ((actionsList.action?.isEmpty) == nil) {
                    completion(actionsList, false, "Data object empty" as? Error)
                } else {
                    completion(actionsList, true, nil)
                }
            }
        }.resume()
    }
    
    // POSTS an action to a device with the device unique identifier and the device new state
    func registerDevice(device: Device, completion: @escaping ( _ success: Bool?, _ error: Error?) -> ()){
        
        guard let url = URL(string: "https://pda-home-automation.herokuapp.com/api/device/") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let params = [
            "name": device.name,
            "deviceType": device.deviceType,
            "state": device.state,
            "room": device.room,
            "receivingTopic": device.receivingTopic,
            "respondingTopic": device.respondingTopic
        ]
        do{
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                     completion(false, error)
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")

                 completion(false, "statusCode should be 2xx, but is \(response.statusCode)" as? Error)
                    return
                }
                print("action sent successfully")
                completion(true, nil)
                
            }.resume()
        } catch {
            completion(false, "Error caught!" as? Error)
        }
    }
    
    // Updates a device with new parameters
    func updateDevice(device: Device, completion: @escaping ( _ success: Bool?, _ error: Error?) -> ()){
        let deviceId = device._id
        guard let url = URL(string: "https://pda-home-automation.herokuapp.com/api/device/\(deviceId!)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        let params = [
            "name": device.name,
            "deviceType": device.deviceType,
            "state": device.state,
            "room": device.room,
            "receivingTopic": device.receivingTopic,
            "respondingTopic": device.respondingTopic
        ]
        do{
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                     completion(false, error)
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")

                 completion(false, "statusCode should be 2xx, but is \(response.statusCode)" as? Error)
                    return
                }
                print("updated successfully")
                completion(true, nil)
                
            }.resume()
        } catch {
            completion(false, "Error caught!" as? Error)
        }
    }
    
    // POSTS an action to a device with the device unique identifier and the device new state
    func sendAction(newState: String, deviceId: String, completion: @escaping ( _ success: Bool?, _ error: Error?) -> ()){
        
        guard let url = URL(string: "https://pda-home-automation.herokuapp.com/api/action/") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let params = ["deviceId": deviceId, "newState": newState]
        do{
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                     completion(false, error)
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")

                 completion(false, "statusCode should be 2xx, but is \(response.statusCode)" as? Error)
                    return
                }
                print("action sent successfully")
                completion(true, nil)
                
            }.resume()
        } catch {
            completion(false, "Error caught!" as? Error)
        }
    }
    
    // Parses an HTTP Data response to a DevicesList
    func parseActions (data: Data) -> ActionsList {
        var actionsList = ActionsList.init(action: []);
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            actionsList = try! decoder.decode(ActionsList.self, from: data)
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
        }
        return actionsList
    }
    
    // Parses an HTTP Data array response to a DevicesList
    func parseDevices (data: Data) -> DevicesList {
        var devicesList = DevicesList.init(device: nil);
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            devicesList = try! decoder.decode(DevicesList.self, from: data)
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
        }
        return devicesList
    }
    
    // Parses an HTTP GET device by ID response to a Device object
    func parseDevice (data: Data) -> Device {
        var device = Device()
        var singleDevice = SingleDevice()
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            singleDevice = try! decoder.decode(SingleDevice.self, from: data)
            
            if(singleDevice.device != nil) {
                device = singleDevice.device!
            }
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
        }
        return device
    }
}



