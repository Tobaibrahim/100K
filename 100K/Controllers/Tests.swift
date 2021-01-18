//
//  Tests.swift
//  100K
//
//  Created by TXB4 on 17/01/2021.
//

import UIKit

class test: UIViewController {

var databaseArray = ["cake","cheese","ham","bacon","bread","cheese","ham","sirloin","sirloin"]
var searchArray = ["cake","cheese","ham","bacon","bread"]
var newArrayItems = [String]()
var appendedItemsArray = [String]()


    override func viewDidLoad() {
        changedIndexValuesFromLoop()
    }

func changedIndexValuesFromLoop() {
    validateArray {(result) in
        print("DEBUG: CHANGED INDEX = \(result)")
        self.addNewItems(values: result)
    }

}


func validateArray(completion:@escaping([String]) -> Void){
    
    var changedIndex         = [String]() // value of index changes
    let difference           = databaseArray.difference(from:searchArray).insertions

    for values in difference { // we have to do this because the enums have the values we need then we append the
        switch values {
        case.insert(_, let element, _):
            // this case gives me access to the changed values (offset)
            changedIndex.append(element)

        case .remove(offset:_ , element: _, associatedWith:_):
            break
        }
    }
    print("DEBUG: CHANGED INDEX = \([changedIndex])")
        
    if changedIndex == [""] {
        changedIndex = []
    }
    else {
        completion(changedIndex)
    }
}




func addNewItems(values:[String]) {

//    newArrayItems.append(searchArray[values])   // index issue
//    AuthService.shared.createHoldingValues(key: self.shopName, value: self.searchArray)

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//        var list = self.databaseArray
//        list.insert(contentsOf: self.newArrayItems, at: 0)
        self.appendedItemsArray.append(contentsOf: values) // Find a way to optimise this
        print(self.appendedItemsArray)
    }
}
    
}
