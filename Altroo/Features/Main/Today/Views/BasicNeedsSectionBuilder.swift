//
//  BasicNeedsSectionBuilder.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 09/11/25.
//

import UIKit

struct BasicNeedsSectionBuilder {
    let viewModel: TodayViewModel
    let delegate: TodayViewControllerDelegate?
    let feedingRecords: [FeedingRecord]
    
    func build(from config: TodaySectionConfig) -> UIView {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 16
        
        let visibleItems = config.subitems?.filter(\.isVisible).map(\.title) ?? []
        
        if visibleItems.contains("Alimentação") {
            let feedingListView = FeedingRecordList()
            feedingListView.update(with: feedingRecords)
            let feedingCard = RecordCard(
                title: "Alimentação",
                iconName: "takeoutbag.and.cup.and.straw.fill",
                contentView: feedingListView
            )
            feedingCard.onAddButtonTap = { delegate?.goTo(.recordFeeding) }
            sectionStack.addArrangedSubview(feedingCard)
        }
        
        if visibleItems.contains("Hidratação") {
            let iconName: String
            if #available(iOS 17.0, *) {
                iconName = "waterbottle.fill"
            } else {
                iconName = "drop.fill"
            }
            let waterValue = viewModel.waterQuantity
            let targetValue = viewModel.currentCareRecipient?.waterTarget ?? 0

            let waterRecord = WaterRecord(
                currentQuantity: "\(waterValue)",
                goalQuantity: "\(targetValue)ml"
            )
            waterRecord.onEditTap = { delegate?.goTo(.recordHydration)
            }

            let hydrationCard = RecordCard(
                title: "Hidratação",
                iconName: iconName,
                showPlusButton: false,
                contentView: waterRecord,
                waterText: "\(Int(viewModel.waterMeasure))ml"
            )
            
            hydrationCard.onAddButtonTap = { viewModel.saveHydrationRecord()
            }

            
            sectionStack.addArrangedSubview(hydrationCard)
        }
        
        if visibleItems.contains("Fezes") || visibleItems.contains("Urina") {
            let bottomRow = UIStackView()
            bottomRow.axis = .horizontal
            bottomRow.spacing = 16
            bottomRow.distribution = .fillEqually
            
            if visibleItems.contains("Fezes") {
                let stoolCard = RecordCard(title: "Fezes", iconName: "toilet.fill", contentView: QuantityRecordContent(quantity: viewModel.todayStoolQuantity))
                stoolCard.onAddButtonTap = { delegate?.goTo(.recordStool)
                }
                
                bottomRow.addArrangedSubview(stoolCard)
            }
            
            if visibleItems.contains("Urina") {
                let iconName: String
                if #available(iOS 17.0, *) {
                    iconName = "drop.halffull"
                } else {
                    iconName = "drop.fill"
                }
                
                let urineCard = RecordCard(title: "Urina", iconName: iconName, contentView: QuantityRecordContent(quantity: viewModel.todayUrineQuantity))
                urineCard.onAddButtonTap = { delegate?.goTo(.recordUrine)
                }
                
                bottomRow.addArrangedSubview(urineCard)
            }
            sectionStack.addArrangedSubview(bottomRow)
        }

        return sectionStack
    }
}
