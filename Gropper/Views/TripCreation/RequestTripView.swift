//
//  RequestTripView.swift
//  Gropper
//
//  Created by Bryce King on 4/30/25.
//

import SwiftUI
import ContactsUI

struct RequestTripView: View {
    @StateObject var viewModel = TripCreationViewModel()
    @State private var displayContactPicker = false
    @Environment(\.dismiss) var dismiss
    var onFormSubmit: () -> Void
    
    var body: some View {
        Form{
            Section(header: Text("Where Do You need Items From?")){
                TextField("Location", text: $viewModel.tripData.location )
                TextField("Location Description", text: $viewModel.tripData.locationDescription)
            }
            Section(header: Text("Who's The Request For?")){
                if(!viewModel.hostContact.phoneNumber.isEmpty) {
                    Text("\(viewModel.hostContact.firstName) \(viewModel.hostContact.lastName ?? "")")
                } else{
                    Text("No Contact Selected")
                }
                Button("Select Contact"){
                    displayContactPicker.toggle()
                }
            }

            Section(header: Text("What Do You need?")){
                if (viewModel.items.count > 0) {
                    List($viewModel.items){$item in
                        TextField("Item Name", text: $item.itemName)
                        TextField("Item Description", text: $item.itemDescription)
                    }
                    
                } else{
                    Section{
                        Text("No Items")
                    }
                }
                Button("Add Item"){
                    if var items = viewModel.tripData.itemsRequested{
                        items.append(ItemInfo(requestor: "1111111111"))
                        viewModel.tripData.itemsRequested = items
                    } else {
                        viewModel.tripData.itemsRequested = [ItemInfo(requestor: "1111111111")]
                    }
                }
            }
        }
        .sheet(isPresented: $displayContactPicker){
            ContactPickerView(onSelectContact: {hostContact in viewModel.hostContact = hostContact
                self.displayContactPicker = false},
                onCancel: { self.displayContactPicker = false })
        }
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Create Trip"){
                    viewModel.requestTrip()
                    dismiss()
                }
                .disabled(viewModel.tripData.location.isEmpty || viewModel.hostContact.phoneNumber.isEmpty)
            }
        }
        .onChange(of: viewModel.successfulTripCreation) {
            if viewModel.successfulTripCreation{
                onFormSubmit()
                dismiss()
            }
        }
    }
    
}
