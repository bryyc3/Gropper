//
//  TripCreationView.swift
//  Gropper
//
//  Created by Bryce King on 7/31/25.
//

import SwiftUI

struct TripCreationView: View {
    let formType: TripCreationType
    @StateObject var viewModel = TripCreationViewModel()
    @State var isFormValid: Bool = false
    @Environment(\.dismiss) var dismiss
    var onFormSubmit: () -> Void
    
    var body: some View {
        Form{
            Section{
                TextField("Location", text: $viewModel.tripData.location )
                TextField("Location Description", text: $viewModel.tripData.locationDescription)
            } header: {
                if (formType == .host) {Text("Where Are You Going?")}
                if (formType == .request) {Text("Where Do You need Items From?")}
            }
        
            Section{
                if (formType == .host) {
                    HStack{
                        if (viewModel.selectedContacts.count > 0) {
                            List(viewModel.selectedContacts, id: \.phoneNumber) { contact in
                                Text("\(contact.firstName) \(contact.lastName ?? "")")
                            }
                        } else{
                            Text("No Contacts Selected")
                        }
                    }
                }
                
                if (formType == .request) {
                    if(viewModel.hostContact.phoneNumber.isEmpty) {
                        Text("No Contact Selected")
                    } else{
                        Text("\(viewModel.hostContact.firstName) \(viewModel.hostContact.lastName ?? "")")
                    }
                }
                
                Button(action:{
                    viewModel.displayContactPicker.toggle()
                }){
                    if(formType == .host){Text("Select Contacts")}
                    if(formType == .request){Text("Select Contact")}
                }
            } header: {
                if(formType == .host){Text("Who can request items?")}
                if(formType == .request){Text("Who's The Request For?")}
            }

            if (formType == .request) {
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
                        viewModel.items.append(ItemInfo())
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Create Trip"){
                    Task{
                        if(formType == .host){viewModel.createHostedTrip()}
                        if(formType == .request){viewModel.requestTrip()}
                    }
                }
                .disabled(!isFormValid)
            }
        }
        .onChange(of: viewModel.successfulTripCreation) {
            if viewModel.successfulTripCreation{
                onFormSubmit()
                dismiss()
            }
        }
    }
    
    private func formValidityCheck() {
        if(formType == .host){
            isFormValid = !viewModel.tripData.location.isEmpty &&
                          !viewModel.selectedContacts.isEmpty
        }
        
        if(formType == .request){
            isFormValid = !viewModel.tripData.location.isEmpty &&
                          !viewModel.hostContact.phoneNumber.isEmpty
        }
        
    }
}

enum TripCreationType {
    case host
    case request
}

#Preview {
    //TripCreation()
}
