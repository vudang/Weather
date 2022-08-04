//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import UIKit
import AlamofireImage
import SnapKit

class ForecastTableViewCell: UITableViewCell {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.kSize)
        return label
    }()
    
    private let avgTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.kSize)
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.kSize)
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.kSize)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.kSize)
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .vertical
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with forecast: Forecast, fontSize: CGFloat = FontSize.kSize) {
        let timeStr = ["Date:", forecast.dayTime?.toDate().toString()]
            .compactMap { $0 }
            .joined(separator: " ")
        let avgTempStr = ["Average Temerature:", forecast.temperature?.averageValue]
            .compactMap { $0 }
            .joined(separator: " ")
        let pressureStr = ["Pressure:", forecast.pressureValue]
            .joined(separator: " ")
        let humidityStr = ["Dumidity:", forecast.humidityValue]
            .joined(separator: " ")
        let descStr = ["Description:", forecast.weather?.first?.weatherDescription]
            .compactMap { $0 }
            .joined(separator: " ")
        
        dateLabel.text = timeStr
        avgTempLabel.text = avgTempStr
        pressureLabel.text = pressureStr
        humidityLabel.text = humidityStr
        descriptionLabel.text = descStr
        
        if let img = forecast.weather?.first?.iconUrl, let url = URL(string: img) {
            iconImageView.af.setImage(withURL: url, cacheKey: img)
        } else {
            iconImageView.image = nil
        }
        
        self.changeFontSize(to: fontSize)
    }
    
    private func changeFontSize(to size: CGFloat) {
        dateLabel.font = UIFont.systemFont(ofSize: size)
        avgTempLabel.font = UIFont.systemFont(ofSize: size)
        pressureLabel.font = UIFont.systemFont(ofSize: size)
        humidityLabel.font = UIFont.systemFont(ofSize: size)
        descriptionLabel.font = UIFont.systemFont(ofSize: size)
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
}

extension ForecastTableViewCell {
    private func layoutView() {
        self.addSubview(contentStackView)
        self.addSubview(iconImageView)
        self.contentStackView.addArrangedSubview(dateLabel)
        self.contentStackView.addArrangedSubview(avgTempLabel)
        self.contentStackView.addArrangedSubview(pressureLabel)
        self.contentStackView.addArrangedSubview(humidityLabel)
        self.contentStackView.addArrangedSubview(descriptionLabel)
        
        self.iconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        self.contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(iconImageView.snp.leading).inset(-20)
        }
    }
}
