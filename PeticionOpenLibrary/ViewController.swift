//
//  ViewController.swift
//  PeticionOpenLibrary
//
//  Created by Jesus Manuel Porras on 8/26/16.
//  Copyright © 2016 Jesus Manuel Porras. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var txtvResultado: UITextView!
    
    
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
                        self.txtvResultado.text = String(texto!)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) { self.txtvResultado.text = "No se encontraron datos con el ISBN especificado."}
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

