//
//  MyHouses.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 4/17/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyHouses {
    var houses = [House]()
    private var remoteHouses = [House]()
    private var deletedHouses = [House]()
    
    static let shared = MyHouses()
    
    private init() {
        loadHouses()
    }
    
    func syncHouses(completion: @escaping (Bool) -> Void) {
        getHousesFromRemote(completion: { success in
            if success {
                self.addHousesToRemote()
                self.deleteHousesFromRemote()
            }
            completion(success)
        })
    }
    
    func pullHouses(completion: @escaping (Bool) -> Void) {
        getHousesFromRemote(completion: { success in
            if success {
                self.houses = self.remoteHouses
            }
            completion(success)
        })
    }
    
    private func getHousesFromRemote(completion: @escaping (Bool) -> Void) {
        if (Networking.token == "") { return }
        let headers = generateHeaders()
        Alamofire.request(Networking.baseURL + "/getHouses", method: .get, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                self.remoteHouses.removeAll()
                let json = JSON(response.data!).arrayValue
                for houseData in json {
                    var data = houseData.dictionaryValue
                    let hid = data["hid"]?.intValue
                    let address = data["address"]?.stringValue
                    let house = House(hid: hid!, address: address!)
                    self.remoteHouses.append(house)
                    var shouldAdd = true
                    for deletedHouse in self.deletedHouses {
                        if deletedHouse.hid == house.hid {
                            shouldAdd = false
                            break
                        }
                    }
                    for oldHouse in self.houses {
                        if oldHouse.hid == house.hid {
                            shouldAdd = false
                            break
                        }
                    }
                    if shouldAdd {
                        self.houses.append(house)
                    }
                }
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func addHousesToRemote() {
        if (Networking.token == "") { return }
        let headers = generateHeaders()
        for (i, house) in houses.enumerated() {
            if house.hid == 0 {
                let parameters: Parameters = ["address": house.address]
                Alamofire.request(Networking.baseURL + "/addHouse", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
                    switch response.result {
                    case .success:
                        let json = JSON(response.data!)
                        self.houses[i].hid = json["hid"].intValue
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func deleteHousesFromRemote() {
        if (Networking.token == "") { return }
        let headers = generateHeaders()
        for (idx, deletedHouse) in deletedHouses.enumerated().reversed() {
            for (i, remoteHouse) in remoteHouses.enumerated().reversed() {
                if deletedHouse.hid == remoteHouse.hid {
                    let parameters: Parameters = ["hid": deletedHouse.hid]
                    Alamofire.request(Networking.baseURL + "/deleteHouse", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
                        switch response.result {
                        case .success:
                            self.remoteHouses.remove(at: i)
                            self.deletedHouses.remove(at: idx)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        deletedHouses.removeAll()
    }
    
    func syncCriteria(for house: House, completion: @escaping (Bool) -> Void) {
        if (house.hid == 0) {
            completion(false)
            return
        }
        getCriteriaForHouse(house: house, completion: { success in
            if success {
                self.addCriteriaToRemote(house: house)
                self.deleteCriteriaFromRemote(house: house)
            }
            completion(success)
        })
    }
    
    private func getCriteriaForHouse(house: House, completion: @escaping (Bool) -> Void) {
        if (Networking.token == "" || house.hid == 0) { return }
        let headers = generateHeaders()
        let parameters: Parameters = ["hid": house.hid]
        Alamofire.request(Networking.baseURL + "/getCriteria", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                for section in 0..<house.criteria.count {
                    house.remoteCriteria[section].removeAll()
                }
                let json = JSON(response.data!).arrayValue
                for criterionData in json {
                    let criterion = Criterion.decodeJSON(data: criterionData.dictionaryValue)
                    let category = criterion.category
                    let index = Category.allValues.index(of: category)!
                    house.remoteCriteria[index].append(criterion)
                    var shouldAdd = true
                    for deletedCriterion in house.deletedCriteria {
                        if deletedCriterion.id == criterion.id {
                            shouldAdd = false
                            break
                        }
                    }
                    for section in house.criteria {
                        for oldCriterion in section {
                            if oldCriterion.id == criterion.id {
                                shouldAdd = false
                                break
                            }
                        }
                    }
                    if shouldAdd {
                        house.criteria[index].append(criterion)
                    }
                }
                completion(true)
            case .failure(let error):
                print("Get criteria failed: " + error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func addCriteriaToRemote(house: House) {
        if (Networking.token == "" || house.hid == 0) { return }
        let headers = generateHeaders()
        for (i, section) in house.criteria.enumerated() {
            for (j, criterion) in section.enumerated() {
                if criterion.id == 0 {
                    let parameters: Parameters = ["hid": house.hid, "name": criterion.name, "category": criterion.category.rawValue]
                    Alamofire.request(Networking.baseURL + "/addCriterion", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
                        switch response.result {
                        case .success:
                            let json = JSON(response.data!)
                            house.criteria[i][j].id = json["id"].intValue
                        case .failure(let error):
                            print("Add criteria to remote error: " + error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func deleteCriteriaFromRemote(house: House) {
        if (Networking.token == "" || house.hid == 0) { return }
        let headers = generateHeaders()
        for (idx, deletedCriterion) in house.deletedCriteria.enumerated().reversed() {
            for remoteSection in house.remoteCriteria {
                for remoteCriterion in remoteSection {
                    if deletedCriterion.id == remoteCriterion.id {
                        let parameters: Parameters = ["hid": house.hid, "id": deletedCriterion.id]
                        Alamofire.request(Networking.baseURL + "/deleteCriterion", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
                            switch response.result {
                            case .success:
                                house.deletedCriteria.remove(at: idx)
                            case .failure(let error):
                                print(error.localizedDescription)
                                print("Delete criteria from remote error: " + error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadHouses() {
        print("Loading houses")
        let defaults = UserDefaults.standard
        if let encodedHouses = defaults.array(forKey: defaultsKeys.houses) {
            houses = [House]()
            for encodedHouse in encodedHouses {
                if let houseData = encodedHouse as? Data {
                    if let house = NSKeyedUnarchiver.unarchiveObject(with: houseData) as? House {
                        houses.append(house)
                    }
                }
            }
        }
    }
    
    func saveHouses() {
        print("Saving houses")
        var encodedHouses = [Data]()
        for house in houses {
            let encodedHouse = NSKeyedArchiver.archivedData(withRootObject: house)
            encodedHouses.append(encodedHouse)
        }
        
        let defaults = UserDefaults.standard
        defaults.setValue(encodedHouses, forKey: defaultsKeys.houses)
        defaults.synchronize()
    }
    
    func clearHouses() {
        houses.removeAll()
    }
    
    func removeHouse(at index: Int) {
        let deletedHouse = houses.remove(at: index)
        deletedHouses.append(deletedHouse)
    }
    
    func addHouse(house: House) {
        houses.append(house)
    }
}
