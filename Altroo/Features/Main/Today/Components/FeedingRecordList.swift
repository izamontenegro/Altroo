//
//  FeedingRecordList.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 21/10/25.
//

import UIKit

class FeedingRecordList: UIView {
    
    private let hStack = UIStackView()
    var feedingRecords: [FeedingRecord] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        update(with: feedingRecords)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hStack)
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            hStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            hStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            hStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
        
    }
    
    func update(with records: [FeedingRecord]) {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        feedingRecords = records
        if feedingRecords.isEmpty {
            let label = StandardLabel(
                labelText: "Nenhum registro hoje.",
                labelFont: .sfPro,
                labelType: .callOut,
                labelColor: .black30
            )
            label.textAlignment = .center
            hStack.addArrangedSubview(label)
            return
        }
        
        for record in feedingRecords {
            let title = record.mealCategory ?? "Sem categoria"
            let statusEnum = FeedingStatus.fromAmountEaten(record.amountEaten)
            let card = FeedingCardRecord(title: title, status: statusEnum)
            hStack.addArrangedSubview(card)
        }
    }
}

extension FeedingStatus {
    static func fromAmountEaten(_ value: String?) -> FeedingStatus {
        switch value?.lowercased() {
        case "tudo":
            return .completed
        case "parcialmente":
            return .partial
        default:
            return .pending
        }
    }
}

#Preview {
    FeedingRecordList()
}
