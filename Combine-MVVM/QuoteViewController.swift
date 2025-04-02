//
//  ViewController.swift
//  Combine-MVVM
//
//  Created by 서정원 on 3/10/25.
//

import Combine
import UIKit

class QuoteViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private let vm: QuoteViewModel = QuoteViewModel()
    private let input: PassthroughSubject<QuoteViewModel.Input, Never> = .init()
    
    private var cancellabels = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchQuoteDidSucced(let quote):
                    self?.quoteLabel.text = quote.content
                case .fetchQuoteDidFail(error: let error):
                    self?.quoteLabel.text = error.localizedDescription
                case .toggleButton(isEnabled: let isEnabled):
                    self?.refreshButton.isEnabled = isEnabled
                }
            }.store(in: &cancellabels)
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        input.send(.refreshButtonDidTap)
    }
}


