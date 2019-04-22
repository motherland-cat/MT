// Fonction pour les pièces jointes
var Joint = {
  i: 1,
  add: function(elem) {

    //Create an input type dynamically.
    var element = document.createElement("input");
    var element2 = document.createElement("input");

    //Assign different attributes to the element.
    element.setAttribute("type", "file");
    element.setAttribute("name", "file"+this.i);

    element2.setAttribute("type", "hidden");
    element2.setAttribute("name", "hidden"+this.i);
    element2.setAttribute("value", "ok");

    if(elem == undefined)
      var foo = document.getElementById("fooBar");
    else
      var foo = elem;
    
    var br = document.createElement("br");

    if(this.i == 1)
    {      
      foo.innerHTML = "<p style='margin-top:10px;'>Types de fichier autorisés : zip, pdf, doc, gif, jpg, png, bmp, txt.<br/>Taille maximale autorisée : 1 Mo par fichier, 5 Mo au total.<br/><b>(Pensez à compresser vos fichiers s'ils sont trop volumineux !)</b></p>";
    }

    this.i = this.i+1;

    //Append the element in page (in span).
    foo.appendChild(element2);
    foo.appendChild(element);
    foo.appendChild(br);
  }
};
