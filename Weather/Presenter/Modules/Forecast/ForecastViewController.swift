//
//  ForecastViewController.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import AVFoundation

protocol ForecastViewOutputs: AnyObject {
    func searchWeatherForecast(with keyword: String)
    func didSelected(_ currency: Forecast)
}

final class ForecastViewController: UIViewController, ForecastViewInputs {
    internal var presenter: ForecastViewOutputs?
    internal let forecastSubject = BehaviorRelay<[Forecast]>.init(value: [])
    private lazy var disposeBag = DisposeBag()
    private var fontSize = FontSize.kSize
    private let synthesizer = AVSpeechSynthesizer()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        navigationItem.title = "Weather Forecast"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .plain, target: self, action: #selector(changeFontPressed))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        configureTableView()
        configureSearchBar()
        configureEmptyView()
    }
    
    private func configureTableView() {
        let cellIdentifier = String(describing: ForecastTableViewCell.self)
        tableView.isHidden = true
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        forecastSubject.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ForecastTableViewCell.self)) { [weak self] (row, data, cell) in
                cell.configure(with: data, fontSize: self?.fontSize ?? FontSize.kSize)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Forecast.self)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] forecast in
                self?.presenter?.didSelected(forecast)
                self?.playTextToSpeed(forecast.textToSpeed)
            }.disposed(by: disposeBag)
        
        forecastSubject.skip(1)
            .map { $0.isEmpty }
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Input your city"
        
        searchController.searchBar.rx.text
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.count > 2 }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] keyword in
                self?.presenter?.searchWeatherForecast(with: keyword)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureEmptyView() {
        emptyView.isHidden = true
        forecastSubject.skip(1)
            .map { !$0.isEmpty }
            .bind(to: emptyView.rx.isHidden )
            .disposed(by: disposeBag)
    }
    
    @objc func changeFontPressed() {
        self.showFontSizeConfig()
    }
    
    private func playTextToSpeed(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}

// MARK: - FontSize Handle
extension ForecastViewController {
    private func showFontSizeConfig() {
        let configView = FontSizeView()
        configView.alpha = 0
        self.navigationController?.view.addSubview(configView)
        configView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.trailing.leading.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            configView.alpha = 1
        }
        
        configView.increaseFont
            .subscribe { [weak self] _ in
                self?.increaseFontSize()
            }.disposed(by: disposeBag)
        
        configView.decreaseFont
            .subscribe { [weak self] _ in
                self?.decreaseFontSize()
            }.disposed(by: disposeBag)
        
        configView.dismissEvent
            .subscribe { _ in
                configView.removeFromSuperview()
            }.disposed(by: disposeBag)
    }
    
    private func increaseFontSize() {
        self.fontSize += 5
        self.fontSize = min(self.fontSize, 35)
        self.tableView.reloadData()
    }
    
    private func decreaseFontSize() {
        self.fontSize -= 5
        self.fontSize = max(self.fontSize, 17)
        self.tableView.reloadData()
    }
}

// MARK: - ForecastViewInputs
extension ForecastViewController {
    func reloadData(_ data: ForecastEntities) {
        tableView.isHidden = false
        emptyView.isHidden = true
        forecastSubject.accept(data.entryEntity.forecasts ?? [])
    }
    
    func onError(_ error: String?) {
        tableView.isHidden = true
        emptyView.isHidden = false
        emptyView.text = error
        forecastSubject.accept([])
    }
    
    func indicator(animate: Bool) {
        DispatchQueue.main.async { [weak self] in
            _ = animate ? self?.indicatorView.startAnimating() : self?.indicatorView.stopAnimating()
        }
    }
}
