//
//  HomeVC.swift
//  NewsFeedDemo
//
//  Created by Zimble on 14/07/21.
//

import UIKit
import WebKit
import SDWebImage
class HomeVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel : HomeViewModel!
    
    var spinner : UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            spinner = UIActivityIndicatorView(style: .medium)
            
        }
        else {
            spinner = UIActivityIndicatorView(style: .white)
        }
        bindToViewModel()
       

        spinner.color = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.nib(), forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        
    }
    
    func bindToViewModel(){
        viewModel = HomeViewModel()
        viewModel.modelData.listener = {[weak self] value in
            self?.spinner?.stopAnimating()
            self?.spinner.isHidden = true
            self?.tableView.reloadData()
            
        }
        
        viewModel.getNewsFeed()
        
    }
    
    
}



extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modelData.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
        guard let item = viewModel.modelData.value?[indexPath.row] else {
            return cell
        }
        cell.newTitle.text = item.title
        let url = URL(string: item.urlToImage)
        
        cell.newImageView?.sd_setImage(with: url, completed: nil)
        
        cell.editorName.text = item.author
        //cell.date.text = newsData[indexPath.row].publishedAt
        cell.newLink.isUserInteractionEnabled = true
        
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue  ] as [NSAttributedString.Key : Any]
        let myAttrString = NSAttributedString(string: item.url, attributes: myAttribute)
        
        // set attributed text on a UILabel
        
        cell.newLink.attributedText = myAttrString
        
        let formattedDate = setDateFormat(date: item.publishedAt)
        print(formattedDate)
        cell.date.text = formattedDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.viewModel.modelData.value?.count ?? 0) - 5 && (self.viewModel.modelData.value?.count ?? 0) >= 10 && !self.viewModel.shouldLoadMore {
            spinner.isHidden = false
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            
            if (self.viewModel.modelData.value?.count ?? 0) > 0{
                spinner.isHidden = false
            }
            
            self.viewModel.getNewsFeed(pageIndex: self.viewModel.offset + 1)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
        if let item = viewModel.modelData.value?[indexPath.row] {
            vc?.newData = item
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

extension HomeVC{
    
    
    func setDateFormat(date: String) -> String {
        let dateArray = date.components(separatedBy: "-")
        var dateFormatted = String()
        print(dateArray[2])
        dateFormatted = dateArray[2].prefix(2) + " "
        dateFormatted +=  (MonthEnum(rawValue: dateArray[1])?.description)! + ", "
        dateFormatted += dateArray[0] + " "
        
        let time = date.components(separatedBy: "T")
        
        let dateAsString = String(time[1].dropLast())
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        
        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"
        
        let time12 = df.string(from: date!)
        print(time12)
        
        dateFormatted += time12
        return dateFormatted
    }
    
}

