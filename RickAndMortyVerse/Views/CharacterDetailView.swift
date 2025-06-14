import SwiftUI
import CoreData
import CachedImageModule

struct CharacterDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: CharacterDetailViewModel
    
    var body: some View {
        Form {
            CachedImageView(imageUrl: viewModel.character.image, size: 300)
            .padding()
            Section(header: Text("Basic information")) {
                SectionDetailRowView(label: "Name", value: viewModel.character.name)
                SectionDetailRowView(
                    label: "Status",
                    value: viewModel.character.status.rawValue.capitalized)
                SectionDetailRowView(
                    label: "Species",
                    value: viewModel.character.species.rawValue.capitalized)

                SectionDetailRowView(
                    label: "Gender",
                    value: viewModel.character.gender.rawValue.capitalized)
            }

            Section(header: Text("Location")) {
                SectionDetailRowView(
                    label: "Origin", value: viewModel.character.origin.name)
                SectionDetailRowView(
                    label: "Location", value: viewModel.character.location.name)
            }

            Section(header: Text("Episodes")) {
                Text("Appears in \(viewModel.character.episode.count) episodes")
                    .font(.subheadline)
            }

            Section(header: Text("Additional details")) {
               
                SectionDetailRowView(label: "Created", value: viewModel.character.created.formatted(date: .numeric, time: .omitted))
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle(viewModel.character.name, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.toogleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                }
            }
        }

    }
}

struct SectionDetailRowView: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}
