import SwiftUI
import CoreData
import CachedImageModule

struct CharacterDetailView: View {
    let character: CharacterModel
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: CharacterDetailViewModel

    init(character: CharacterModel, context: NSManagedObjectContext) {
        self.character = character
        self._viewModel = State(initialValue: CharacterDetailViewModel(character: character, context: context))
    }
    
    var body: some View {
        Form {
            CachedImageView(imageUrl: character.image, size: 300)
            .padding()
            Section(header: Text("Basic information")) {
                SectionDetailRowView(label: "Name", value: character.name)
                SectionDetailRowView(
                    label: "Status",
                    value: character.status.rawValue.capitalized)
                SectionDetailRowView(
                    label: "Species",
                    value: character.species.rawValue.capitalized)

                SectionDetailRowView(
                    label: "Gender",
                    value: character.gender.rawValue.capitalized)
            }

            Section(header: Text("Location")) {
                SectionDetailRowView(
                    label: "Origin", value: character.origin.name)
                SectionDetailRowView(
                    label: "Location", value: character.location.name)
            }

            Section(header: Text("Episodes")) {
                Text("Appears in \(character.episode.count) episodes")
                    .font(.subheadline)
            }

            Section(header: Text("Additional details")) {
               
                SectionDetailRowView(label: "Created", value: character.created.formatted(date: .numeric, time: .omitted))
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle(character.name, displayMode: .inline)
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
