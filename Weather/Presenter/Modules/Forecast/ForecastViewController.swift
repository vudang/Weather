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

protocol ForecastViewOutputs: AnyObject {
    func searchWeatherForecast(with keyword: String)
    func didSelected(_ currency: Forecast)
}

final class ForecastViewController: UIViewController, ForecastViewInputs, Viewable {
    internal var presenter: ForecastViewOutputs?
    internal let forecastSubject = BehaviorRelay<[Forecast]>.init(value: [])
    private lazy var disposeBag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        navigationItem.title = "Weather Forecast"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        configureTableView()
        configureSearchBar()
        configureEmptyView()
    }
    
    private func configureTableView() {
        let cellIdentifier = String(describing: ForecastTableViewCell.self)
        tableView.isHidden = true
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        forecastSubject.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ForecastTableViewCell.self)) { (row, data, cell) in
                cell.configure(with: data)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Forecast.self)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] forecast in
                self?.presenter?.didSelected(forecast)
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
