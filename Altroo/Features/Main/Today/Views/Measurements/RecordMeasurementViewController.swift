//
//  RecordMeasurementViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//
import UIKit

enum MeasurementType: String {
    case heartRate, glycemia, bloodPressure, temperature, saturation
}

class RecordMeasurementViewController: UIViewController {
    var measurementType: MeasurementType

    init(measurementType: MeasurementType) {
        self.measurementType = measurementType

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Record Measurement View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewLabel.text = "Record \(measurementType.rawValue) View"

        view.backgroundColor = .white
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
