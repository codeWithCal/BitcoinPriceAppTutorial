//
//  ViewController.swift
//  BitcoinTrackerTutorial
//
//  Created by CallumHill on 6/8/21.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var btcPrice: UILabel!
	@IBOutlet weak var ethPrice: UILabel!
	@IBOutlet weak var usdPrice: UILabel!
	@IBOutlet weak var audPrice: UILabel!
	@IBOutlet weak var lastUpdatedPrice: UILabel!
	
	let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		fetchData()
		
		_ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
	}
	
	@objc func refreshData() -> Void
	{
		fetchData()
	}
	
	func fetchData()
	{
		let url = URL(string: urlString)
		let defaultSession = URLSession(configuration: .default)
		let dataTask = defaultSession.dataTask(with: url!) {
			(data: Data?, response: URLResponse?,error: Error?) in
			
			if(error != nil)
			{
				print(error!)
				return
			}
			
			do
			{
				let json = try JSONDecoder().decode(Rates.self, from: data!)
				self.setPrices(currency: json.rates)
			}
			catch
			{
				print(error)
				return
			}
			
			
		}
		dataTask.resume()
	}
	
	func setPrices(currency: Currency)
	{
		DispatchQueue.main.async
		{
			self.btcPrice.text = self.formatPrice(currency.btc)
			self.ethPrice.text = self.formatPrice(currency.eth)
			self.usdPrice.text = self.formatPrice(currency.usd)
			self.audPrice.text = self.formatPrice(currency.aud)
			self.lastUpdatedPrice.text = self.formatDate(date: Date())
		}
	}
	
	func formatPrice(_ price: Price) -> String
	{
		return String(format: "%@ %.6f", price.unit, price.value)
	}
	
	func formatDate(date: Date) -> String
	{
		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMM y HH:mm:ss"
		return formatter.string(from: date)
	}

	struct Rates: Codable
	{
		let rates: Currency
	}
	
	struct Currency: Codable
	{
		let btc: Price
		let eth: Price
		let usd: Price
		let aud: Price
	}
	
	struct Price: Codable
	{
		let name: String
		let unit: String
		let value: Float
		let type: String
	}
	
}

//{
//   "rates":{
//	  "btc":{
//		 "name":"Bitcoin",
//		 "unit":"BTC",
//		 "value":1.0,
//		 "type":"crypto"
//	  },
//	  "eth":{
//		 "name":"Ether",
//		 "unit":"ETH",
//		 "value":14.504,
//		 "type":"crypto"
//	  },
//	  "usd":{
//		 "name":"US Dollar",
//		 "unit":"$",
//		 "value":40411.784,
//		 "type":"fiat"
//	  },
//	  "aud":{
//		 "name":"Australian Dollar",
//		 "unit":"A$",
//		 "value":54744.592,
//		 "type":"fiat"
//	  },
//   }
//}

