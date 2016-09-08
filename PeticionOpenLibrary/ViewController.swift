//
//  ViewController.swift
//  PeticionOpenLibrary
//
//  Created by Jesus Manuel Porras on 8/26/16.
//  Copyright © 2016 Jesus Manuel Porras. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtAutor: UILabel!
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var imgPortada: UIImageView!
    //@IBOutlet weak var txtvResultado: UITextView!
    
    @IBOutlet weak var txtTit: UILabel!
    var jsonTxt: String = ""
    
    //----------manejo de campo de texto----------
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let isbn: String? = self.txtISBN.text!
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn!
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let dt = sesion.dataTaskWithURL(url!) { (let datos, let resp, let error) in
            if let httpResponse = resp as? NSHTTPURLResponse {
                print (httpResponse.statusCode)
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                
                if (String(texto!) != "{}") {
                    dispatch_async(dispatch_get_main_queue()) {
                        //************************************************************inicio
                        
                        //------------FUNCIONES DE JSON----------------
                        
                        let datos = NSData(contentsOfURL: url!)
                        do{
                            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options:NSJSONReadingOptions.MutableLeaves)
                            let dico1 = json as! NSDictionary
                            let root = dico1["ISBN:\(isbn!)"] as! NSDictionary
                            let title = root["title"] as! NSString as String
                            dispatch_async(dispatch_get_main_queue()) {
                                self.txtTitulo.text = title
                            }
                            //self.imgPortada.image = UIImage(named: "sinImagen.png")
                            
                            
                            if (root["cover"] != nil){
                                let cover = root["cover"] as! NSDictionary
                                let medium = cover["medium"] as! NSString as String
                                //self.imgPortada.image.URL
                                if let url = NSURL(string: medium) {
                                    if let data = NSData(contentsOfURL: url) {
                                        dispatch_async(dispatch_get_main_queue()) {self.imgPortada.image = UIImage(data: data)}
                                    }
                                } else {
                                    dispatch_async(dispatch_get_main_queue()) {self.imgPortada.image = UIImage(named: "sinImagen.png")}
                                }
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue()) {self.imgPortada.image = UIImage(named: "sinImagen.png")}
                            }
                            
                            
                            let authors = root["authors"] as! NSArray
                            
                            var autoresCad: String = ""
                            
                            for i in 0...authors.count-1{
                                autoresCad += ("\(authors[i]["name"] as! NSString as String)\n")
                                
                                print(authors[i]["name"])
                            }
                            dispatch_async(dispatch_get_main_queue()) {self.txtAutor.text = autoresCad}
                            
                        } catch _ {
                            
                        }
                        //*******************************************fin
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alert = UIAlertController(title: "Error", message:
                            "No se encontró ISBN especificado.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    //self.txtvResultado.text = "Error al conectar con el sitio. Verifique su conexión a Internet."
                    let alert = UIAlertController(title: "Error", message:
                        "Error al conectar con el sitio. Verifique su conexión a Internet.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                }
            }
        }
        dt.resume()
        return true
    }
    
    //-------------manejo de teclado--------------
    
    @IBAction func textFieldDoneEditing (sender: UITextField){
        sender.resignFirstResponder() //desaparece el teclado
    }
    
    @IBAction func backgroundTap(sender: UIControl){ //UIControl en de UIView para que salga la acción de touchDown del Control
        txtISBN.resignFirstResponder()
    }
    
    //----------Ciclo de vida-----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtISBN.delegate = self  //señalamos que se va a delegar en si mismo mediante unmetodo en la misma clase
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

