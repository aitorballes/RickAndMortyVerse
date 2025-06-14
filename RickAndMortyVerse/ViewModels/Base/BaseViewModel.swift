import Foundation
protocol BaseViewModel {
    var isLoading: Bool { get set }
    var errorMessage: String { get set }
    var showError: Bool { get set }
}
