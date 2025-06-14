import Foundation

extension String {
    func extractPageNumber() -> String? {
        guard !self.isEmpty else { return nil }
        
        let pattern = "\\?page=(\\d+)"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self)),
              let range = Range(match.range(at: 1), in: self) else { return nil }
        
        return String(self[range])
    }
}
