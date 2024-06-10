var ns4 = 0 ;
var ie  = 0 ;
var ns6 = 0 ;
// ===========================================
// Init des browsers
if (document.all)
{
  ie=1;
}
if ( document.getElementById && !document.all )
{
  ns6=1;
}
if (document.layers)
{
  ns4=1;
}


function change(element,button) {
    if (ns4) 
    {
      theobject=document.layers[element];
      theimage=document.layers[button];
    }  
    if (ie||ns6)
    {
      theobject = ie? eval(document.all[element]) : document.getElementById(element);
      theimage=ie? eval(document.all[button]) : document.getElementById(button);
    }
	if ( theobject.style.visibility == 'visible' ) 
	{
		theobject.style.visibility = 'hidden';
        theobject.style.display = 'none';
        theimage.src = 'ouvrir.gif';
	}
	else 
	{
		theobject.style.visibility = 'visible';
		theobject.style.display = '';
		theimage.src = 'fermer.gif';
	}
}

