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
        
        if let myURL = getURLFromInput() {
            var message = ""
            
            let myRequest = NSMutableURLRequest(url: myURL)
            
            let myTask = URLSession.shared.dataTask(with: myRequest as URLRequest) { data, response, error in
                if error != nil {
                    print(error!)
                } else {
                    
                    if let unwrappedData = data {
                        
                        if let dataNSString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) {
                            
                            message = self.getForecastFromData(dataNSString: dataNSString)
                            
                        }
                    }
                }
                
                if message == "" {
                    message = "The weather there couldn't be found, please try again."
                }
                
                DispatchQueue.main.async(execute: {
                    self.weatherDescription.text = message
                })
            }
            myTask.resume()
                
        } else {
            weatherDescription.text = "Couldn't get valid location."
        }

    }
    
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func getURLFromInput() -> URL? {
        
        if (textField.text?.isEmpty)! {
            return nil
        }
        
        let frontURLString = "http://www.weather-forecast.com/locations/"
        let backURLString = "/forecasts/latest"
        
        if let newStringInput = textField.text?.replacingOccurrences(of: " ", with: "-") {
            let newURLString = frontURLString + newStringInput + backURLString
            if let returnURL = URL(string: newURLString) {
                return returnURL
            } else { return nil }
        } else { return nil }
    }
    
     /*
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
    */
    func getForecastFromData(dataNSString: NSString) -> String {
        if dataNSString.contains("The page you were looking for doesn't exist (404)") {
            return "Not a valid location."
        } else {
            var separatorString = "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">" // code directly before forecast
            
            let contentArray = dataNSString.components(separatedBy: separatorString)
            if contentArray.count > 0 {
                separatorString = "</span></span></span>" // update value to reflect code immediately after forecast
                let newContentArray = contentArray[1].components(separatedBy: separatorString)
                if newContentArray.count > 0 {
                    return newContentArray[0].replacingOccurrences(of: "&deg;", with: "°") as String
                }
            }
            return ""
        }
    }
    /*
    func displayWeatherDescription(webForecast: String) {
        weatherDescription.text = webForecast
    }
    */
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

