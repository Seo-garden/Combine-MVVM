import Combine
import UIKit

protocol QuoteServiceType {
    func getRandomQuote() async throws -> Quote
}

class QuoteService: QuoteServiceType {
    func getRandomQuote() async throws -> Quote {
        let url = URL(string: "http://api.quotable.io/random")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Quote.self, from: data)
    }
    
//    func getRandomQuote() -> AnyPublisher<Quote, Error> {       //네트워크를 처리하는 과정에서 에러 발생 가능 -> Error
//        let url = URL(string: "http://api.quotable.io/random")!
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .catch { error in
//                return Fail(error: error).eraseToAnyPublisher()
//            }.map({ $0.data })
//            .decode(type: Quote.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()      //얘는 cancellables와 차이가 뭔가?
//    }
}
