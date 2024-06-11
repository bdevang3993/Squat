//
//  CustomTableDataSource.swift
//  AllInOneTravels
//
//  Created by devang bhavsar on 07/12/21.
//

import UIKit
public protocol CustomTableDataSource {
    func numberOfRows() -> Int
    func heightForRow() -> CGFloat
}
public protocol CustomTableDelegate {
    func numberOfItemAtIndex<T>(index:Int) -> T
}
class CustomTableView: NSObject {
    var  dataSource:CustomTableDataSource!
    var  delegate:CustomTableDelegate!

}
