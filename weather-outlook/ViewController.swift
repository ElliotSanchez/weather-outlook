//
//  ViewController.swift
//  weather-outlook
//
//  Created by hostname on 11/14/16.
//  Copyright © 2016 notungood. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "http://www.weather-forecast.com/locations/London/forecasts/latest")
        
        let myRequest = NSMutableURLRequest(url: myURL!)
        
        let myTask = URLSession.shared.dataTask(with: myRequest as URLRequest) { data, response, error in
            if error != nil {
                print(error!)
            } else {
                if let unwrappedData = data {
                    let dataNSString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)!
                    print(dataNSString)
                }
            }
        }
        myTask.resume()
    }
    
    @IBAction func getWeatherTapped(_ sender: Any) {
        /*
        if let userInput = textField.text {
            if let userURL = createURLFromInput(input: userInput) {
                if let rawHTMLString = getWeatherData(url: userURL) {
                    DispatchQueue.main.sync(execute: {
                        if let webForecastString = getForecastFromData(rawData: rawHTMLString) {
                            displayWeatherDescription(webForecast: webForecastString)
                        } else {
                            print("couldn't get data from web")
                        }
                    })
                }
            }
        }
 */
        print("nothing happens when tapped")
    }
    
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    
    
    /*
    func createURLFromInput(input: String) -> URL? {
        let newNSStringInput = NSString(string: input)
        newNSStringInput.replacingOccurrences(of: " ", with: "-")
        let newURLString = frontURLString + (newNSStringInput as String) as String + backURLString
        if let returnURL = URL(string: newURLString) {
            return returnURL
        } else {
            print ("error getting url from input")
            return nil
        }
    }
    
    func getWeatherData(url: URL) -> String? {
        let request = NSMutableURLRequest(url: url)
        var dataNSString = NSString()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error!)
            } else {
                if let unwrappedData = data {
                    dataNSString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)!
                    let dataString = dataNSString as String
                } else {
                    print("could not get unwrapped data from URLSession dataTask")
                }
            }
        }
        task.resume()
    }
    
    func getForecastFromData(rawData: String) -> String? {
        
    }
    
    func displayWeatherDescription(webForecast: String) {
        weatherDescription.text = webForecast
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

