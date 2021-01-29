//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Anadea Lukačević on 21/01/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WeatherViewController: UIViewController {
    
    private lazy var cityNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.becomeFirstResponder()
        tf.placeholder = "Type city name"
        return tf
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 42)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "temperature 🙈"
        return label
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 42)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "humidity 🙈"
        return label
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather App"
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        addSubviews()
        makeConstraints()
        tfEditingEnded()
    }
    
    private func addSubviews() {
        view.addSubview(cityNameTextField)
        view.addSubview(temperatureLabel)
        view.addSubview(humidityLabel)
    }
    
    private func makeConstraints() {
        cityNameTextField.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(155)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(cityNameTextField.snp.bottom).offset(80)
        }
        humidityLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(80)
        }
    }
    
    private func tfEditingEnded() {
        self.cityNameTextField
            .rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else { return }
        let resource = Resource<WeatherResult>(url: url)
        
        //USING DRIVER AND CONTROLPROPERTY
        let search = URLRequest
            .load(resource: resource)
            .observeOn(MainScheduler.instance)
        
        search
            .map { "\($0.main.temp) 𝗙" }
            .asDriver(onErrorJustReturn: "Wrong")
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search
            .map { "\($0.main.humidity) 💦"}
            .asDriver(onErrorJustReturn: "city name")
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
// 2nd method - USING BIND
//        let search = URLRequest
//            .load(resource: resource)
//            .observeOn(MainScheduler.instance)
//            .catchErrorJustReturn(WeatherResult.empty)
//
//        search
//            .map{ "\($0.main.temp) 𝗙" }
//            .bind(to: self.temperatureLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        search
//            .map { "\($0.main.humidity) 💦"}
//            .bind(to: self.humidityLabel.rx.text)
//            .disposed(by: disposeBag)
        
// 1st method - USING SUBSCRIBE
        //        URLRequest
        //            .load(resource: resource)
        //            .observeOn(MainScheduler.instance)
        //            .catchErrorJustReturn(WeatherResult.empty)
        //            .subscribe(onNext: { result in
        //                let weather = result.main
        //                self.displayWeather(weather)
        //            }).disposed(by: disposeBag)
        
    }
    
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) 𝗙"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        } else {
            self.temperatureLabel.text = "🙈"
            self.humidityLabel.text = "💦"
        }
    }
}
