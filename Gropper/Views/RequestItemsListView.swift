//
//  RequestItemsListView.swift
//  Gropper
//
//  Created by Bryce King on 4/30/25.
//

import SwiftUI

struct RequestItemsListView: View {
    @Binding var itemsArray: [RequestedItem]
    var body: some View {
        ForEach($itemsArray){
            $item in TextField("Item Name", text: $item.name)
            TextField("Item Description", text: $item.description)
        }
    }
}
