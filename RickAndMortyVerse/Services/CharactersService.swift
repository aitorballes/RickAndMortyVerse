import Foundation

class CharactersService {

    private let httpService: HttpServiceBase

    init(httpService: HttpServiceBase = HttpServiceBase.shared) {
        self.httpService = httpService
    }

    func getCharacters(completion: @escaping (CharactersRequestModel?) -> Void)
    {
        httpService.get(from: "character", completion: completion)
    }

    func getCharactersByPage(
        page: String, completion: @escaping (CharactersRequestModel?) -> Void
    ) {
        httpService.get(from: "character?page=\(page)", completion: completion)
    }
}
