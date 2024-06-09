function displayMonitoring(myXMLfile, myXSLfile, KOorNot) {
		
	if (window.navigator.appName == 'Microsoft Internet Explorer') {
		
		var xslt = new ActiveXObject("Msxml2.XSLTemplate.4.0"); 
		var xslDoc = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.4.0"); 
		var xmlDoc = new ActiveXObject("Msxml2.DOMDocument.4.0"); 
		var xslProc;
		xslDoc.async = false; 
		xslDoc.load(myXSLfile); 
		xslt.stylesheet = xslDoc; 
		xmlDoc.async = false; 
		xmlDoc.load(myXMLfile); 
		xslProc = xslt.createProcessor(); 
		xslProc.input = xmlDoc; 
		xslProc.addParameter("currentDate",getCurrentDate());
		if (KOorNot == "KO")
			xslProc.addParameter("KOorNot","KO");
		xslProc.transform(); 
		document.body.innerHTML=xslProc.output;
	}
	else {
	
		var xslt= document.implementation.createDocument("", "", null);
		xslt.async=false;
		xslt.load(myXSLfile);
		processor =new XSLTProcessor();
		processor.importStylesheet(xslt);
		xmlDoc= document.implementation.createDocument("", "", null);
		xmlDoc.async=false;
		xmlDoc.load(myXMLfile);
		processor.setParameter(null,"currentDate", getCurrentDate());
		if (KOorNot == "KO")
			processor.setParameter(null,"KOorNot","KO");
		var resultat = processor.transformToFragment(xmlDoc,document);
		document.body.innerHTML = ""
		document.body.appendChild(resultat);
	}
}

function getCurrentDate()
{
	var now    = new Date();
   
   var monthnumber = now.getMonth() + 1;
   var monthday    = now.getDate();
   var year        = now.getYear();
   if(year < 2000) { year = year + 1900; }
   var hour   = now.getHours();
   if (hour<10) {hour = "0" + hour}
   var minute = now.getMinutes();
   if (minute<10) {minute = "0" + minute}
   var second = now.getSeconds();
   if (second<10) {second = "0" + second}
   
   var dateString = monthnumber + '/' + monthday + '/' + year + ' ' + hour + ':' + minute;
   return dateString;

}
