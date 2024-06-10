// Déclaration d'une variable avec portée globale
var mafenetre = null;
/* -------------------------------------------------------------------- */
// HideShowDIV
// Change la visibilité du DIV dont le nom est passe en parametre : */
/* -------------------------------------------------------------------- */

function HideShowDIV(id_DIV){
	
	var divAModifier = document.getElementById(id_DIV);
	var liAModif = document.getElementById("LI_"+id_DIV);
	
	  
	if ( divAModifier.style.display == "none" ) {
		divAModifier.style.display = "list-item";
		/*liAModif.style.listStyleImage = "url(nolines_minus.gif)";*/
	}
	else {
		divAModifier.style.display = "none";
		/*liAModif.style.listStyleImage = "url(nolines_plus.gif)";*/
	}
}


/* -------------------------------------------------------------------- */
// HideShowLargeViewDIV
/* -------------------------------------------------------------------- */

function ShowLargeViewDIV(imageName){
	
	/* Version div fixe à utliser quand internet explorer respectera le standard ( marchotte avec ie7)
	/*var divAModifier = document.getElementById("LargeViewID");
	var largeViewImage = document.getElementById("LargeViewImage");
	
	largeViewImage.src=imageName;
	divAModifier.style.visibility = "visible";*/
	
	//alert(mafenetre);	
	if (! mafenetre || (typeof(mafenetre) == "undefined") || ( mafenetre.closed == true) )
	{
	    //alert(imageName);
	    mafenetre = window.open(imageName,'imageName','toolbar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes,width=820,height=620');
	    /*if( mafenetre.Unload = 'mafenetre=0;';*/
	    
	    // Gestion d'événement sur le unload
	    /*if (mafenetre.addEventListener)
	    {
	       // version pour mozilla et les autres
	       mafenetre.addEventListener('unload', InitWindow, false);
	    }
	    else if (mafenetre.attachEvent)
	    {
	        //alert(imageName);
	       // Version pour Internet explorer
	       mafenetre.attachEvent('onbeforeunload', InitWindow);
	    }*/
	}
	else
	{ 
	    mafenetre.location=imageName;
	}
	mafenetre.focus();
}

function InitWindow()
{
    mafenetre=null;
}

/*function addEvent(oElem, sEvType, fn, bCapture)
{
   alert(sEvType);
   return oElem.addEventListener?
      oElem.addEventListener(sEvType, fn, bCapture):
      oElem.attachEvent?
         oElem.attachEvent('on' + sEvType, fn):
         oElem['on' + sEvType] = fn;
}*/


// addEvent(mafenetre, 'unload', InitWindow, false);


/* -------------------------------------------------------------------- */
// HideLargeViewDIV
/* -------------------------------------------------------------------- */

function HideLargeViewDIV(){
	
	var divAModifier = document.getElementById("LargeViewID");
	divAModifier.style.visibility = "hidden";
	
}

/* -------------------------------------------------------------------- */
// HideShowMessagesStatus
// Afficher seulement les messages de la severité passée en parametre */
// uniquement pour la reference passée en paramentre
/* -------------------------------------------------------------------- */
function HideShowMessagesStatus  ( bouton, statusID, reference ) {
	var littags = document.getElementsByTagName('li');
	for(j=0;j<littags.length;j++)
	{		
	    var statusOfGroup = trim(littags[j].id).substring(3,10);
	    /*alert(statusOfGroup);
	    alert(statusID);*/
	    if (trim(littags[j].id).substring(3,10)== statusID)
	    {
	        if(bouton.checked)
	        {
				littags[j].style.display = "list-item";
				//littags[j].style.listStyleImage = "url(nolines_plus.gif)";
			}
			else 
			{
				littags[j].style.display = "none";
				//littags[j].style.listStyleImage = "url(nolines_minus.gif)";
			}
	  
	    }
	        
		//on elimine d'entree les chaines vides
		/*if(littags[j].id != "")
		{	
			//on ne selectionne que les elements de la reference selectionnee
			if(trim(littags[j].id).substring(3, littags[j].id.length) == reference)
			{
				if(trim(littags[j].id).substring(0,7) == statusID)
				{
					if(bouton.checked){
						littags[j].style.display = "list-item";
					}
					else {
						littags[j].style.display = "none";
					}
				}
			}
		}*/
	}		
}

/* -------------------------------------------------------------------- */
// load
// Fonction lancée à chaque chargement de la page
// Par defaut, on cache les elements et messages d'information
/* -------------------------------------------------------------------- */
function load(){
	//Masquage des elements de type "Information"
	var littags = document.getElementsByTagName('li');
	for(j=0;j<littags.length;j++)
	{		
		//on elimine d'entree les chaines vides
		//if( (trim(littags[j].id).substring(0,7) == "NotInsp") )
		if (littags[j].statusID == "NotInsp")
		{
			littags[j].style.display = "none";
		}
	}	
	
	//Gestion des cases à cocher ("Show info" non cochée par defaut, les autres oui)
	var checkboxes = document.getElementsByTagName('input');
	for(j=0;j<checkboxes.length;j++)
	{		
		if(checkboxes[j].id == "Ignored")
		{
			checkboxes[j].checked = true;
		}
		if(checkboxes[j].id == "OKAreas")
		{
			checkboxes[j].checked = true;
		}
		if(checkboxes[j].id == "KOAreas")
		{
			checkboxes[j].checked = true;
		}

	}	
}

/* -------------------------------------------------------------------- */
// trim
// Fonction privée permettant d'enlever les espaces dans un string
//Auteur : kwj
/* -------------------------------------------------------------------- */
function trim(str) {
    return str.replace(/^\s+/, '').replace(/\s+$/, '');
}

