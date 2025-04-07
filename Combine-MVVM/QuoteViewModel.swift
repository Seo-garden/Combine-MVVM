//
//  QuoteViewModel.swift
//  Combine-MVVM
//
//  Created by 서정원 on 3/12/25.
//

import Combine

class QuoteViewModel {
    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }
    
    enum Output {
        case fetchQuoteDidFail(error: Error)
        case fetchQuoteDidSucced(quote: Quote)
        case toggleButton(isEnabled: Bool)
    }
    
    //DI
    private let quoteServiceType: QuoteServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellabels = Set<AnyCancellable>()
    
    
    init(quoteServiceType: QuoteServiceType = QuoteService()) {
        self.quoteServiceType = quoteServiceType
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
            input.sink { [weak self] event in
                switch event {
                case .viewDidAppear, .refreshButtonDidTap:
                    Task {
                        await self?.handleGetRandomQuote()
                    }
                }
            }.store(in: &cancellabels)
            return output.eraseToAnyPublisher()
        }
    

    
    private func handleGetRandomQuote() async {
        output.send(.toggleButton(isEnabled: false))
        
        do {
            let quote = try await quoteServiceType.getRandomQuote()
            output.send(.fetchQuoteDidSucced(quote: quote))
        } catch {
            output.send(.fetchQuoteDidFail(error: error))
        }
        
        output.send(.toggleButton(isEnabled: true))
    }
    
//    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
//        //절대 실패할 가능성이 없음
//                input.sink { [weak self] event in
//                    switch event {
//                    case .viewDidAppear, .refreshButtonDidTap:
//                        self?.handlegetRandomQuote()
//                    }
//                }.store(in: &cancellabels)
//                return output.eraseToAnyPublisher()
//    }
    

//    private func handlegetRandomQuote() {
//        output.send(.toggleButton(isEnabled: false))
//        quoteServiceType.getRandomQuote()
//            .sink { [weak self] completion in
//                self?.output.send(.toggleButton(isEnabled: true))
//                if case .failure(let error) = completion {
//                    self?.output.send(.fetchQuoteDidFail(error: error))
//                }
//            } receiveValue: { [weak self] quote in
//                self?.output.send(.fetchQuoteDidSucced(quote: quote))
//            }.store(in: &cancellabels)
//    }
    
    
}
