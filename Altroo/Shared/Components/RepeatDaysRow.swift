//
//  RepeatDaysRow.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//
import UIKit

final class RepeatDaysRow: UIStackView {
    var didSelectDay: ((Locale.Weekday, Bool) -> Void)?
    private var dayButtons: [CheckOptionButton] = []
    
    private var wrappingView: FlowLayoutView?
    
    private let selectedDays: [Locale.Weekday]
    
    init(selectedDays: [Locale.Weekday] = []) {
        self.selectedDays = selectedDays
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.width > 0, wrappingView == nil {
            makeDayButtons(maxWidth: bounds.width)
        }
    }
    
    
    private func makeDayButtons(maxWidth: CGFloat) {
        let buttons: [UIButton] = Locale.Weekday.allWeekDays.enumerated().map { index, day in
            let button = CheckOptionButton(title: day.localizedSymbol(style: .full).capitalized)
            button.isSelected = selectedDays.contains(day)
            button.associatedData = day
            button.tag = index
            button.addTarget(self, action: #selector(didTapDay(_:)), for: .touchUpInside)
            
            dayButtons.append(button)
            return button
        }
        
        let wrap = FlowLayoutView(views: buttons, maxWidth: maxWidth)
        wrap.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(wrap)
        wrappingView = wrap
        
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: topAnchor),
            wrap.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrap.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrap.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    
    @objc private func didTapDay(_ sender: CheckOptionButton) {
        guard let day = sender.associatedData as? Locale.Weekday else { return }
        sender.isSelected.toggle()
        
        didSelectDay?(day, sender.isSelected)
    }
    
    //TODO: SEE IF STILL NEEDED
    func updateSelectedDays(_ days: [Locale.Weekday]) {
        for button in dayButtons {
            guard let day = button.associatedData as? Locale.Weekday else { continue }
            button.backgroundColor = days.contains(day) ? .teal20 : .black40
        }
    }
    
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addSpacer(to row: UIStackView) {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        row.addArrangedSubview(spacer)
    }
}
