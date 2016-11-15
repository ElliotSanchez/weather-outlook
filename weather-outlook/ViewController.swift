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

        var message: String? = nil
        
        if let myURL = getURLFromInput() {
            
            //getRawNSStringFromURL(url: myURL)
            
            let myRequest = NSMutableURLRequest(url: myURL)
            
            let myTask = URLSession.shared.dataTask(with: myRequest as URLRequest) { data, response, error in
                if error != nil {
                    print(error!)
                } else {
                    
                    if let unwrappedData = data {
                        
                        if let dataNSString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) {
                            
                            if self.getForecastFromRawNSString(dataNSString: dataNSString) != nil {
                                message = self.getForecastFromRawNSString(dataNSString: dataNSString)
                            }
                            
                        }
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    if message != nil {
                        self.weatherDescription.text = message
                    } else {
                        self.weatherDescription.text = "Couldn't get weather for that location."
                    }
                })
            }
            myTask.resume()
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
    
    
    func getRawNSStringFromURL(url: URL) -> String? {
        
        return nil

    }
 
    func getForecastFromRawNSString(dataNSString: NSString) -> String? {
        if dataNSString.contains("The page you were looking for doesn't exist (404)") {
            return nil
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
            return nil
        }
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

