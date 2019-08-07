//
//  KorisniciController.swift
//  MojGrad
//
//  Created by Ja on 07/08/2019.
//  Copyright © 2019 Ja. All rights reserved.
//

import UIKit

class KorisniciController: UIViewController {

    var korisnici = [Korisnici]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        korisnici = createUsers()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self as? UISearchBarDelegate
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

extension KorisniciController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return korisnici.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let korisnik = korisnici[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "korisnikCell") as! KorisnikCell
        
        cell.korisnikImage.image = korisnik.korisnikImage
        cell.imeKorisnika.text = korisnik.korisnikIme
        cell.emailKorisnika.text = korisnik.korisnikEmail
        
        return cell
    }
}
