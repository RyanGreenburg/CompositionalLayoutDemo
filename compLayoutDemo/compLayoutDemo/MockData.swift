//
//  MockData.swift
//  compLayoutDemo
//
//  Created by RYAN GREENBURG on 1/25/21.
//

import UIKit

protocol Diffable {
    var id: UUID { get }
}

struct ColorItem: Hashable, Diffable {
    let color: UIColor
    let id = UUID()
}

struct Section: Hashable {
    enum Context: String, Hashable {
        case feature
        case swimlane
        case grid
        case list
        case nested
    }
    
    let context: Context
    let items: [ColorItem]
    
    var title: String {
        context.rawValue.capitalized
    }
}

struct MockData {
    
    static let colors: [Section] = {
        let red = ColorItem(color: .red)
        
        let blues = [ColorItem(color: .blue),
                     ColorItem(color: .blue),
                     ColorItem(color: .blue)]
        
        let greens = [ColorItem(color: .green),
                      ColorItem(color: .green),
                      ColorItem(color: .green),
                      ColorItem(color: .green)]
        
        let purples = [ColorItem(color: .purple),
                       ColorItem(color: .purple)]
        
        let yellows = [ColorItem(color: .yellow),
                       ColorItem(color: .yellow),
                       ColorItem(color: .yellow),
                       ColorItem(color: .yellow),
                       ColorItem(color: .yellow)]
        
        let cyans = [ColorItem(color: .cyan),
                     ColorItem(color: .cyan),
                     ColorItem(color: .cyan),
                     ColorItem(color: .cyan),
                     ColorItem(color: .cyan)]
        
        return [Section(context: .feature, items: [red]),
        Section(context: .swimlane, items: blues),
        Section(context: .list, items: greens),
        Section(context: .feature, items: purples),
        Section(context: .grid, items: yellows),
        Section(context: .nested, items: cyans)
    ]}()
}
