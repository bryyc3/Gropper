//
//  HostTripView.swift
//  Gropper
//
//  Created by Bryce King on 4/12/25.
//

import SwiftUI
import ContactsUI

struct HostTripView: View {
    @StateObject var viewModel = TripCreationViewModel()
    @State private var displayContactPicker = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("Where Are You Going?")){
                    TextField("Location", text: $viewModel.tripData.location )
                    TextField("Location Description", text: $viewModel.tripData.locationDescription)
                }
                Section(header: Text("Who can request items?")){
                    HStack{
                        if (viewModel.selectedContacts.count > 0) {
                            List(viewModel.selectedContacts, id: \.phoneNumber) { contact in
                                Text("\(contact.firstName) \(contact.lastName ?? "")")
                            }
                        } else{
                            Text("No Contacts Selected")
                        }
                    }
                    Button("Select Contacts"){
                        displayContactPicker.toggle()
                    }
                }
                
            }
            .sheet(isPresented: $displayContactPicker){
                MultipleContactsPickerView(
                    onSelectContacts: {selectedContacts in viewModel.selectedContacts = selectedContacts
                    self.displayContactPicker = false},
                    onCancel: { self.displayContactPicker = false })
            }
            
        }
        
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Create Trip"){
                    viewModel.createHostedTrip()
                    dismiss()
                }
                .disabled(viewModel.tripData.location.isEmpty || viewModel.selectedContacts.isEmpty)
            }
        }
    }
}

#Preview {
    HostTripView()
}
