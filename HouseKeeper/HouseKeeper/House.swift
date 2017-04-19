//
//  House.swift
//  Open House
//
//  Created by Arjun Chib on 11/11/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

// House class
class House: NSObject, NSCoding {
    
    var hid = 0
    var address = ""
    var rank = 0.0
    var matchingRatio: [Double] = [Double](repeating: 0.0, count: Category.allValues.count)
    var image = UIImage(named: "Placeholder")
    var criteria: [[Criterion]] = Array(repeatElement([Criterion](), count: Category.allValues.count))
    var remoteCriteria: [[Criterion]] = Array(repeatElement([Criterion](), count: Category.allValues.count))
    var deletedCriteria: [Criterion] = [Criterion]()

    override public var description: String { return "\(hid): \(address)" }
    
    override init() {}

    init(hid: Int, address: String) {
        self.address = address
        self.hid = hid
    }
    
    required init(coder aDecoder: NSCoder) {
        hid = aDecoder.decodeInteger(forKey: "hid") 
        address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        rank = aDecoder.decodeDouble(forKey: "rank")
        image = aDecoder.decodeObject(forKey: "image") as? UIImage ?? UIImage(named: "Placeholder")
        criteria = aDecoder.decodeObject(forKey: "criteria") as? [[Criterion]] ?? [[Criterion]]()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hid, forKey: "hid")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(criteria, forKey: "criteria")
    }
    
    func addCriterion(criterion: Criterion, to section: Int) {
        criteria[section].append(criterion)
    }
    
    func addCriterion(criterion: Criterion, to section: Category) {
        if let index = Category.allValues.index(of: section) {
            addCriterion(criterion: criterion, to: index)
        }
    }
    
    func removeCriterion(index: Int, from section: Int) {
        let deletedCriterion = criteria[section].remove(at: index)
        deletedCriteria.append(deletedCriterion)
    }
    
    func syncCriteriaWithDreamHouse() {
        if self == DreamHouse.shared { return }
        print("dream sync")
        for (sectionIndex, dreamSection) in DreamHouse.shared.criteria.enumerated() {
            for dreamCriterion in dreamSection {
                var shouldAdd = true
                for (index, criterion) in criteria[sectionIndex].enumerated().reversed() {
                    if criterion.name.lowercased() == dreamCriterion.name.lowercased() {
                        print(criterion, dreamCriterion)
                        if criterion.type != dreamCriterion.type {
                            removeCriterion(index: index, from: sectionIndex)
                            shouldAdd = true
                        } else {
                            shouldAdd = false
                        }
                        break
                    }
                }
                if shouldAdd {
                    let newCriterion = Criterion(id: 0)
                    newCriterion.name = dreamCriterion.name
                    newCriterion.type = dreamCriterion.type
                    newCriterion.category = dreamCriterion.category
                    newCriterion.isDream = true
                    addCriterion(criterion: newCriterion, to: sectionIndex)
                }
            }
        }
        for (sectionIndex, section) in criteria.enumerated().reversed() {
            for (index, criteria) in section.enumerated().reversed() {
                if criteria.isDream {
                    var shouldDelete = true
                    for dreamCriteria in DreamHouse.shared.criteria[sectionIndex] {
                        if criteria.name.lowercased() == dreamCriteria.name.lowercased() {
                            shouldDelete = false
                            break
                        }
                    }
                    if shouldDelete {
                        removeCriterion(index: index, from: sectionIndex)
                    }
                }
            }
        }
    }
    
    func calculateRank() {
        rank = 0.0
        var total = 0.0
        var correct = 0.0
        for (sectionIndex, section) in criteria.enumerated() {
            var sectionTotal = 0.0
            var sectionCorrect = 0.0
            for criterion in section {
                if criterion.isDream {
                    for dreamCriteria in DreamHouse.shared.criteria[sectionIndex] {
                        if dreamCriteria.name == criterion.name {
                            sectionTotal += 1
                            if dreamCriteria.value == criterion.value {
                                sectionCorrect += 1
                            }
                        }
                    }
                }
            }
            if sectionTotal > 0.0 {
                matchingRatio[sectionIndex] = sectionCorrect / sectionTotal
            } else {
                matchingRatio[sectionIndex] = 0.0
            }
            total += sectionTotal
            correct += sectionCorrect
        }
        if total > 0 {
            rank = correct / total
        }
    }
}
