//
//  KorisniciController.swift
//  MojGrad
//
//  Created by Ja on 07/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit
import SwiftyJSON

class UsersViewController: UIViewController {

    var allUsers = [JSON]()
    var searching = false
    
    var usersData = APIUsers()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downlaodDataFromService()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downlaodDataFromService), name: Notification.Name(NewUserController.CONSTANT_REFRESH_USERS), object: nil)
        
    }
    
    @objc func downlaodDataFromService(searchWord: String? = nil) {
        usersData.fetchUsersData(searchWord: searchWord) { dataJSON in
            guard let data = dataJSON else {
                return
            }
            if let users = data["data"]["user"].array {
                self.allUsers = users
                self.tableView.reloadData()
            }
        }
    }
}
// TODO: Vedran - USING CLASS EXTENSION TO ADOPT PROTOCOLS LIKE THIS IS NICE, GOOD JOB
extension UsersViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = allUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "korisnikCell") as! UserCell
        
//            cell.korisnikImage.image = korisnik.korisnikImage
        cell.imeKorisnika.text = user["firstName"].string
        cell.emailKorisnika.text = user["email"].string

        return cell
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        downlaodDataFromService(searchWord: searchText)
        
    }
}
