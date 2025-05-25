import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(coinPrice: Double)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "31d77cca-cb4e-4ba7-be15-035791c0e127"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let finalURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        // 1. Create url
        let url = URL(string: finalURL)
        // 2. create URLsession
        let session = URLSession(configuration: .default)
        //3.  Give SessionTask
        let task = session.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let safeData = data{
                let bitcoinPrice = self.parseJSON(safeData)
            }
        }
           //4. Start task
           task.resume()
        }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decoderData.rate
            return lastPrice
        } catch {
            print(error)
            return nil
        }
    }
    
    
    }
