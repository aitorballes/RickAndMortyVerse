import SwiftUI

struct CharactersFilterView: View {
   
    @Binding var selectedGender: Gender?
    @Binding var selectedStatus: Status?
    @Binding var selectedSpecies: Species?

    var body: some View {
        HStack {
            
            Picker("Gender", selection: $selectedGender) {
                Text("Gender")
                    .font(.footnote)
                    .tag(nil as Gender?)
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue.capitalized)
                        .font(.footnote)
                        .tag(gender as Gender?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accessibilityIdentifier("genderPicker")

            Picker("Status", selection: $selectedStatus) {
                Text("Status")
                    .font(.footnote)
                    .tag(nil as Status?)
                ForEach(Status.allCases, id: \.self) { status in
                    Text(status.rawValue.capitalized)
                        .font(.footnote)
                        .tag(status as Status?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accessibilityIdentifier("statusPicker")

            
            Picker("Species", selection: $selectedSpecies) {
                Text("Species")
                    .font(.footnote)
                    .tag(nil as Species?)
                ForEach(Species.allCases, id: \.self) { species in
                    Text(species.rawValue.capitalized)
                        .font(.footnote)
                        .tag(species as Species?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accessibilityIdentifier("speciesPicker")

            
            Spacer()
        }
    }
}
