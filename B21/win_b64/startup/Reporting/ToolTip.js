/*
	**************** java Script for Tool tip - Raki 06-14-2004 *************

	Script written to show the Task times of a Resource Task
	This script creates a tool tip , reads the values from the
	svg file and displays them in the Viewer
	It shows the
		TaskTime
		StartTime
		EndTime
	
*/


function ToolTip(doc, sz)
{
   
   svgdoc1 = doc;
   this.element = null;  // element to show title of ..
   ToolTip.size = sz;      // text size ..
   ToolTip.scl = doc.getDocumentElement().getCurrentScale();     // scaling modified by zooming ..
   ToolTip.off = doc.getDocumentElement().getCurrentTranslate(); // offset modified by zooming ..
     	
   this.Create(doc);
   AddTitleEvents(doc.getDocumentElement());
   window.svgTitle = this;
}

ToolTip.prototype.Create = function(doc)
{
   this.rec = doc.createElement("rect");
   this.rec.setAttribute("y", -0.9*ToolTip.size);
   this.rec.setAttribute("x", -0.25*ToolTip.size);
   this.rec.setAttribute("rx", 0.25*ToolTip.size);
   this.rec.setAttribute("ry", 0.25*ToolTip.size);
   this.rec.setAttribute("width", "1");
   this.rec.setAttribute("height", 1.25*ToolTip.size);
         this.rec.setAttribute("style","fill:lavender;stroke:darkgrey;stroke-width:0.5px;opacity:.7;"); 			

   this.str0 = doc.createTextNode("");
   this.str1 = doc.createTextNode("");
   this.str2 = doc.createTextNode("");
   this.str3 = doc.createTextNode("");
	
   this.txt0 = doc.createElement("text")
   this.txt0.setAttribute("style","fill:darkred;font-size:11px;opacity:.7;"); 
   this.txt0.appendChild(this.str0);
   this.txt0.setAttribute("x", 0);
   this.txt0.setAttribute("y", -0.9 * ToolTip.size + ToolTip.size);

   this.txt1 = doc.createElement("text")
   this.txt1.setAttribute("style","fill:darkred;font-size:11px;opacity:.7;"); 
   this.txt1.appendChild(this.str1);
   this.txt1.setAttribute("x", 0);
   this.txt1.setAttribute("y", -0.9 * ToolTip.size + 2*ToolTip.size);

 
   this.txt2 = doc.createElement("text")	
   this.txt2.setAttribute("style","fill:darkred;font-size:11px;opacity:.7;"); 
   this.txt2.appendChild(this.str2);
   this.txt2.setAttribute("x", 0);
   this.txt2.setAttribute("y", -0.9 * ToolTip.size + 3* ToolTip.size);

   this.txt3 = doc.createElement("text")	
   this.txt3.setAttribute("style","fill:darkred;font-size:11px;opacity:.7;"); 
   this.txt3.appendChild(this.str3);
   this.txt3.setAttribute("x", 0);
   this.txt3.setAttribute("y", -0.9 * ToolTip.size + 4* ToolTip.size);

   this.grp = doc.createElement("g"),
   this.grp.setAttribute("transform", "translate(0,0)");
   this.grp.setAttribute("visibility", "hidden");
   this.grp.appendChild(this.rec);
   this.grp.appendChild(this.txt0);
   this.grp.appendChild(this.txt1);
   this.grp.appendChild(this.txt2);
   this.grp.appendChild(this.txt3);

   doc.getDocumentElement().appendChild(this.grp);
}

ToolTip.Activate = function ToolTip_Activate(evt)
{
   if (window.svgTitle.element == null)
   {
	  ToolTip.scl = svgdoc1.getDocumentElement().getCurrentScale();     
	  ToolTip.off = svgdoc1.getDocumentElement().getCurrentTranslate();

       //var  x = (evt.getClientX() - ToolTip.off.getX())/ToolTip.scl -100;
      var vbox = svgdoc1.getDocumentElement().getAttribute("viewBox");
      var ht = svgdoc1.getDocumentElement().getAttribute("height");
      var wd = svgdoc1.getDocumentElement().getAttribute("width");
      var str_array = vbox.split(" ");
   
       var  x = (evt.getClientX() - ToolTip.off.getX())/(ToolTip.scl *((wd/str_array[2]))) -150;
       var   y = (evt.getClientY()- ToolTip.off.getY())/(ToolTip.scl*(ht/str_array[3])) + 20;
       //var   y = (evt.getClientY()- ToolTip.off.getY())/ToolTip.scl ;
	
      window.svgTitle.element = evt.getCurrentTarget();
	window.svgTitle.element.removeEventListener("mouseover", ToolTip.Activate, false);
      window.svgTitle.element.addEventListener("mouseout", ToolTip.Passivate, false);

      window.svgTitle.str0.setNodeValue((TitleElementOf(window.svgTitle.element,"Name")));   
	   window.svgTitle.str1.setNodeValue((TitleElementOf(window.svgTitle.element,"Duration")));
      window.svgTitle.str2.setNodeValue((TitleElementOf(window.svgTitle.element,"StartTime")));
      window.svgTitle.str3.setNodeValue((TitleElementOf(window.svgTitle.element,"EndTime")));
      

	window.svgTitle.rec.setAttribute("width", window.svgTitle.txt0.getComputedTextLength() + 0.5*ToolTip.size);
      window.svgTitle.rec.setAttribute("height", 4.25 *ToolTip.size);
      
	window.svgTitle.grp.setAttribute("transform", "translate(" + x + "," + y + ")");
	
      window.svgTitle.grp.setAttribute("visibility", "visible");
   }
}

ToolTip.MouseMoved = function ToolTip_MouseMoved(evt)
{
	var  x = (evt.getClientX() - ToolTip.off.getX())/ToolTip.scl -320;
	window.svgTitle.str1.setNodeValue(x);
   var newscl = evt.getTarget().getOwnerDocument().getDocumentElement().getCurrentScale();
   var vbox = svgdoc1.getDocumentElement().getAttribute("viewBox");
   var ht = svgdoc1.getDocumentElement().getAttribute("height");
   var wd = svgdoc1.getDocumentElement().getAttribute("width");
   var str_array = vbox.split(" ");
   //alert(wd/str_array[2]);	

	  ToolTip.scl = svgdoc1.getDocumentElement().getCurrentScale();     
	  ToolTip.off = svgdoc1.getDocumentElement().getCurrentTranslate();

       var  x = (evt.getClientX() - ToolTip.off.getX())/(ToolTip.scl *((wd/str_array[2]))) -150;
       //if( x < 150)
       // x = x - 50 ; // this is a compensation for the tool tip
       var   y = (evt.getClientY()- ToolTip.off.getY())/(ToolTip.scl*(ht/str_array[3])) + 20;// -250;
	
      window.svgTitle.element = evt.getCurrentTarget();
	
	//window.svgTitle.element.removeEventListener("mousemove", ToolTip.Activate, false);
	window.svgTitle.element.addEventListener("mouseout", ToolTip.Passivate, false);

      
	   window.svgTitle.str0.setNodeValue((TitleElementOf(window.svgTitle.element,"Name")));
      window.svgTitle.str1.setNodeValue((TitleElementOf(window.svgTitle.element,"Duration")));
      window.svgTitle.str2.setNodeValue((TitleElementOf(window.svgTitle.element,"StartTime")));
      window.svgTitle.str3.setNodeValue((TitleElementOf(window.svgTitle.element,"EndTime")));
     

	window.svgTitle.rec.setAttribute("width", window.svgTitle.txt0.getComputedTextLength() + 0.5*ToolTip.size);
      window.svgTitle.rec.setAttribute("height", 4.25 *ToolTip.size);
      
	window.svgTitle.grp.setAttribute("transform", "translate(" + x + "," + y + ")");
	
      window.svgTitle.grp.setAttribute("visibility", "visible");

}
ToolTip.Passivate = function ToolTip_Passivate(evt)
{
   if (window.svgTitle.element != null)
   {
      window.svgTitle.grp.setAttribute("visibility", "hidden");
      window.svgTitle.element.removeEventListener("mouseout", ToolTip.Passivate, false);
      window.svgTitle.element.addEventListener("mouseover", ToolTip.Activate, false);
	window.svgTitle.element.addEventListener("mousemove", ToolTip.MouseMoved, false);

      window.svgTitle.element = null;
   }
}

function ToolTip_Zoom(evt)
{
	/************ NOT USED ************/
/*
   var newscl = evt.getTarget().getOwnerDocument().getDocumentElement().getCurrentScale();

//         window.svgTitle.grp.setAttribute("transform", "scale(" + 1/newscl + ")" );
//         alert(1/newscl);	

   ToolTip.size *= ToolTip.scl/newscl;
   ToolTip.scl = newscl;
   ToolTip.off = evt.getTarget().getOwnerDocument().getDocumentElement().getCurrentTranslate();

   window.svgTitle.rec.setAttribute("y", -0.9*ToolTip.size);
   window.svgTitle.rec.setAttribute("x", -0.25*ToolTip.size);
   window.svgTitle.rec.setAttribute("height", 1.25*ToolTip.size);
   window.svgTitle.rec.setAttribute("style", "stroke:black;fill:#edefc2;stroke-width:" + 1/ToolTip.scl);
   window.svgTitle.txt0.setAttribute("style", "font-family:Arial; font-size:" + ToolTip.size + ";fill:black;");
   window.svgTitle.txt1.setAttribute("style", "font-family:Arial; font-size:" + ToolTip.size + ";fill:black;");
   window.svgTitle.txt2.setAttribute("style", "font-family:Arial; font-size:" + ToolTip.size + ";fill:black;");
   window.svgTitle.txt3.setAttribute("style", "font-family:Arial; font-size:" + ToolTip.size + ";fill:black;");
*/
}

ToolTip.Register = function ToolTip_Register(elem)
{
   if (TitleElementOf(elem,"Duration") != "")
      {
		elem.addEventListener("mouseover", ToolTip.Activate, false);
		elem.addEventListener("mousemove", ToolTip.MouseMoved, false);
	}
}

// --- local functions ------------------------

function TextOf(elem)
{
   var childs = elem ? elem.getChildNodes() : null;

   for (var i=0; childs && i<childs.getLength(); i++)
      if (childs.item(i).getNodeType() == 3) // text node ..
         return childs.item(i).getNodeValue();
   
   return "";
}

function AddTitleEvents(elem)
{
   var childs = elem.getChildNodes();

   for (var i=0; i<childs.getLength(); i++)
      if (childs.item(i).getNodeType() == 1) // element node ..
         AddTitleEvents(childs.item(i));

   if (TitleElementOf(elem,"Duration") != "")
      	{
			elem.addEventListener("mouseover", ToolTip.Activate, false);
			elem.addEventListener("mousemove", ToolTip.MouseMoved, false);
		}
}

function TitleElementOf(elem ,elemName )
	{
	   var childs = elem.getChildNodes();
	   var retval="";
	   for (var i=0; i<childs.getLength(); i++)
	   if (childs.item(i).getNodeType() == 1 && childs.item(i).getNodeName() ==  elemName)
	      {
	      		var grandchild = childs.item(i) ? childs.item(i).getChildNodes() :null;
			for (var x=0; grandchild && x<grandchild.getLength(); x++)
	   			if (grandchild.item(x).getNodeType() == 3) // text node ..
					     retval =  childs.item(i).getNodeName() + "   " + grandchild.item(x).getNodeValue() + '\n'; 
	      }
	         return retval;
	   
	}

// === end ======================================================
