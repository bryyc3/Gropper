//
//  AddRequestorsForm.swift
//  Gropper
//
//  Created by Bryce King on 12/16/25.
//

import SwiftUI

struct AddRequestorsForm: View {
    let tripId: String
    var onFormSubmit: () -> Void
    
    @State private var displayContactPicker = false
    @State private var addRequestors: ApiResponse = ApiResponse(status200: true, message: nil)
    @StateObject var viewModel = AddRequestorsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form{
            Section(header: Text("Add New Requestors to Your Trip")) {
                if (viewModel.selectedContacts.count > 0) {
                    Section{
                        List(viewModel.selectedContacts, id: \.phoneNumber) { contact in
                            Text("\(contact.contactName ?? "")")
                        }
                    }
                } else{
                    Text("No Contacts Selected")
                }
                Button("Select Contacts"){
                    displayContactPicker.toggle()
                }
                .sheet(isPresented: $displayContactPicker){
                    MultipleContactsPickerView(onSelectContacts: {
                        selectedContacts in viewModel.selectedContacts = selectedContacts
                        self.displayContactPicker = false},
                                               onCancel: { self.displayContactPicker = false })
                }
                .toolbar{
                    ToolbarItem(placement: .confirmationAction){
                        Button("Submit"){
                            Task{
                                addRequestors = try await viewModel.addRequestors(trip: tripId)
                            }
                        }
                        .disabled(!canSubmit)
                        .onChange(of: viewModel.successfullyAdded) {
                            if viewModel.successfullyAdded{
                                onFormSubmit()
                                dismiss()
                            }
                        }
                    }
                }
            }
            Text("Cannot add requestors to a trip if the contact doesnt have a phone number")
                .font(.system(size: 10, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            if (addRequestors.status200 == false) {
                Text(addRequestors.message ?? "Error Adding Requestors")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    var canSubmit: Bool {
        !viewModel.selectedContacts.isEmpty
    }
}
