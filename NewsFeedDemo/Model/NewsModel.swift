import Foundation

import Alamofire

struct NewsModel{
   
    static func getData(url: URL, completionHandler: @escaping([ArticleModel]) -> Void){

        var news = [ArticleModel]()
        
        let request = AF.request(url)
        
        request.responseData{ response in
            switch response.result{
            case .success(let data):
                do{
                   
                    if let json =   try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if let array = json["articles"] as? [[String:Any]] {
                        
                      news = array.map({ArticleModel(fromDictionary: $0)})
                        }
                       
                        completionHandler(news)
                    }
                   
                   
                }catch{
                    print("Cannot parse data")
                }
            case .failure:
                print("Cannot parse data")
            }
        }
        

     }
}
