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
            print("myURL set - \(myURL)")
                
            if let rawString = self.getRawNSStringFromURL(myURL: myURL) {
                print("rawString set - \(rawString)")
                message = self.getForecastFromRawNSString(dataNSString: rawString)
                print("message set - \(message)")
                
                DispatchQueue.main.async {
                    if message != nil {
                        self.weatherDescription.text = message
                    } else {
                        self.weatherDescription.text = "Couldn't find weather for that location"
                    }
                }
            } else {
                print("debug: didn't get rawString from getRawNSStringFromURL and missed your chance")
            }
        }
    }
    
            /*
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
            */
    
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func getURLFromInput() -> URL? {
        print("1 - getURLFromInput called")
        
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
    
    
    func getRawNSStringFromURL(myURL: URL) -> NSString? {
        print("2 - getRawNSStringFromURL called")
        
        var dataNSStringToReturn :NSString? = nil
        
        let myRequest = NSMutableURLRequest(url: myURL)
        
        let myTask = URLSession.shared.dataTask(with: myRequest as URLRequest) {
            data, response, error in
            print("2.1 myTask code called")
            if error != nil {
                print(error!)
            } else {
                if let unwrappedData = data {
                    dataNSStringToReturn = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    print("2.2 no error in myTask, dataNSStringToReturn set")
                }
            }
        }
        myTask.resume()
        print("2.3 returning dataNSStringToReturn")
        return dataNSStringToReturn
    }
 
    func getForecastFromRawNSString(dataNSString: NSString) -> String? {
        print("3 - getForecastFromRawNSString called")
        
        if dataNSString.contains("The page you were looking for doesn't exist (404)") {
            return nil
        } else {
            var separatorString = "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">" // code directly before forecast
            
            let contentArray = dataNSString.components(separatedBy: separatorString)
            if contentArray.count > 1 {
                separatorString = "</span></span></span>" // update value to reflect code immediately after forecast
                let newContentArray = contentArray[1].components(separatedBy: separatorString)
                if newContentArray.count > 1 {
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

