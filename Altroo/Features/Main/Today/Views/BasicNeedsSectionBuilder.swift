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
        
        if visibleItems.contains("feeding".localized) {
            let feedingListView = FeedingRecordList()
            feedingListView.update(with: feedingRecords)
            let feedingCard = RecordCard(
                title: "feeding".localized,
                iconName: "takeoutbag.and.cup.and.straw.fill",
                contentView: feedingListView
            )
            feedingCard.onAddButtonTap = { delegate?.goTo(.recordFeeding) }
            sectionStack.addArrangedSubview(feedingCard)
        }
        
        if visibleItems.contains("hydration".localized) {
            let iconName: String
            if #available(iOS 17.0, *) {
                iconName = "waterbottle.fill"
            } else {
                iconName = "drop.fill"
            }
            
            let waterRecord = WaterRecord(currentQuantity: "\(viewModel.waterQuantity)", goalQuantity: "\(viewModel.getWaterTarget()/1000)L")
            waterRecord.onEditTap = { delegate?.goTo(.recordHydration)
            }

            let hydrationCard = RecordCard(
                title: "hydration".localized,
                iconName: iconName,
                showPlusButton: false,
                contentView: waterRecord,
                waterText: "\(Int(viewModel.waterMeasure))ml"
            )
            
            hydrationCard.onAddButtonTap = { viewModel.saveHydrationRecord()
            }

            
            sectionStack.addArrangedSubview(hydrationCard)
        }
        
        if visibleItems.contains("stool".localized) || visibleItems.contains("urine".localized) {
            let bottomRow = UIStackView()
            bottomRow.axis = .horizontal
            bottomRow.spacing = 16
            bottomRow.distribution = .fillEqually
            
            if visibleItems.contains("stool".localized) {
                let stoolCard = RecordCard(title: "stool".localized, iconName: "toilet.fill", contentView: QuantityRecordContent(quantity: viewModel.todayStoolQuantity))
                stoolCard.onAddButtonTap = { delegate?.goTo(.recordStool)
                }
                
                bottomRow.addArrangedSubview(stoolCard)
            }
            
            if visibleItems.contains("urine".localized) {
                let iconName: String
                if #available(iOS 17.0, *) {
                    iconName = "drop.halffull"
                } else {
                    iconName = "drop.fill"
                }
                
                let urineCard = RecordCard(title: "urine".localized, iconName: iconName, contentView: QuantityRecordContent(quantity: viewModel.todayUrineQuantity))
                urineCard.onAddButtonTap = { delegate?.goTo(.recordUrine)
                }
                
                bottomRow.addArrangedSubview(urineCard)
            }
            sectionStack.addArrangedSubview(bottomRow)
        }

        return sectionStack
    }
}
