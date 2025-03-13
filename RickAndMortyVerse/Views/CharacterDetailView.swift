import SwiftUI
import CoreData

struct CharacterDetailView: View {
    let character: CharacterModel
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: CharacterDetailViewModel

    init(character: CharacterModel, context: NSManagedObjectContext) {
        self.character = character
        self._viewModel = State(initialValue: CharacterDetailViewModel(character: character, context: context))
    }

    private func formatDate(_ dateString: String) -> String {
        let imputFormatter = DateFormatter()
        imputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = imputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            
            return outputFormatter.string(from: date)
        }
      
        return dateString
    }
    var body: some View {

        Form {
            CustomImageView(
                imageUrl: character.image, width: 300, height: 300,
                cornerRadius: 20
            )
            .padding()
            Section(header: Text("Información Básica")) {
                SectionDetailRowView(label: "Nombre", value: character.name)
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
                SectionDetailRowView(label: "Created", value: formatDate(character.created))
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

//#Preview {
//    CharacterDetailView(
//        character: .init(
//            id: 1,
//            name: "Rick Sanchez",
//            status: .alive,
//            species: .human,
//            type: "Type",
//            gender: .male,
//            origin: .init(
//                name: "Earth (C-137)",
//                url: "https://rickandmortyapi.com/api/location/1"
//            ),
//            location: .init(
//                name: "Citadel of Ricks",
//                url: "https://rickandmortyapi.com/api/location/3"
//            ),
//            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
//            episode: [
//                "https://rickandmortyapi.com/api/episode/1",
//                "https://rickandmortyapi.com/api/episode/2",
//                "https://rickandmortyapi.com/api/episode/3",
//                "https://rickandmortyapi.com/api/episode/4",
//                "https://rickandmortyapi.com/api/episode/5",
//                "https://rickandmortyapi.com/api/episode/6",
//            ],
//            url: "https://rickandmortyapi.com/api/character/1",
//            created: "2017-11-04T18:48:46.250Z"
//        )
//    )
//}
