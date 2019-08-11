//
//  KorisniciController.swift
//  MojGrad
//
//  Created by Ja on 07/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    var korisnici = [Korisnici]()
    var searchUser = [Korisnici]()
    var searching = false
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        korisnici = createUsers()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        
    }
    
    func createUsers() -> [Korisnici] {
        
        var tmpKorisnici = [Korisnici]()
        
        let korisnik1 = Korisnici(korisnikImage: UIImage(named: "zok")!, korisnikIme: "Ivan", korisnikEmail: "dk@gg.com")
        let korisnik2 = Korisnici(korisnikImage: UIImage(named: "zok")!, korisnikIme: "Dom", korisnikEmail: "dk@gg.com")
        let korisnik3 = Korisnici(korisnikImage: UIImage(named: "zok")!, korisnikIme: "Jakov", korisnikEmail: "dk@gg.com")
        let korisnik4 = Korisnici(korisnikImage: UIImage(named: "zok")!, korisnikIme: "Josip", korisnikEmail: "dk@gg.com")
        let korisnik5 = Korisnici(korisnikImage: UIImage(named: "zok")!, korisnikIme: "Marko", korisnikEmail: "dk@gg.com")
        
        tmpKorisnici.append(korisnik1)
        tmpKorisnici.append(korisnik2)
        tmpKorisnici.append(korisnik3)
        tmpKorisnici.append(korisnik4)
        tmpKorisnici.append(korisnik5)
        
        return tmpKorisnici
    }

}

extension UsersViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchUser.count
        } else {
            return korisnici.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let korisnik = korisnici[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "korisnikCell") as! UserCell
        
        if searching {
            cell.imeKorisnika.text = searchUser[indexPath.row].korisnikIme
        } else {
            cell.korisnikImage.image = korisnik.korisnikImage
            cell.imeKorisnika.text = korisnik.korisnikIme
            cell.emailKorisnika.text = korisnik.korisnikEmail
        }
        return cell
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUser = korisnici.filter({$0.korisnikIme.prefix(searchText.count) == searchText})
        searching = true
        tableView.reloadData()
    }
}
