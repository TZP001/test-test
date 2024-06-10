/************************************************************************
 * Date helpers
 ************************************************************************/
// prereqs:
//  - CATJDialog.js
//  - Popupwindow.js

// --- load js file only once
if((typeof LOAD_CALENDAR_JS) == "undefined") {
LOAD_CALENDAR_JS = true;

// --- localized tables
if(typeof DayNames=='undefined')
{
	var DayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
	var SundayIndex = 0;
}
if(typeof MonthNames=='undefined'){var MonthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];}
if(typeof CalendarCommands=='undefined'){var CalendarCommands = ["&lt;&lt;Year", "&lt;Month", "Month&gt;", "Year&gt;&gt;"];}
if(typeof CalDateFormat=='undefined'){var CalDateFormat = "yyyy-MM-dd";}
if(typeof dateOKIconURI=='undefined')
{
	var dateOKIconURI = "greendot.gif";
	var dateKOIconURI = "reddot.gif";
}

var DayWidths = [14, 14, 14, 14, 14, 14, 16];
var DaysInMonth = [31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

function getNbOfDays(month, year)
{
	// --- calculate only for february
	if(month != 1)
		return DaysInMonth[month];
	
	if ((year % 4) == 0 && !((year % 100) == 0 && (year % 400) != 0))
		return 29;
	
	return 28;
}

/*
JOUR
d: numero de jour (sur 1 car si possible)
dd: numero de jour (sur 2 cars)
EE: nom du jour (sur 3 car?)
EEEE: nom du jour complet

MOIS
M: numero de mois (sur 1 car si possible)
MM: numero de mois (sur 2 cars)
MMM: nom du mois (3 cars)
MMMM: nom du mois (complet)

ANNEE
yy: annee (2 cars)
yyyy: annee (4 cars)
*/
function formatDate(day, month, year, format)
{
	var formatedDate = "";
	var readingString = false;
	var idx = 0;
	while(idx < format.length)
	{
		var c = format.charAt(idx);
		if(readingString)
		{
			if(c == '\'')
				readingString = false;
			else
				formatedDate = formatedDate+c;
			idx++;
		}
		else
		{
			if(c == 'd')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'd') {
					idx++;
					nb++;
				}
				
				if(nb == 1) {
					formatedDate = formatedDate+day;
				} else if(nb == 2) {
					formatedDate = day < 10 ? formatedDate+"0"+day : formatedDate+day;
				}
			}
			else if(c == 'E')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'E') {
					idx++;
					nb++;
				}
				
				var date = new Date(year, month, day);
				var dayInWeek = date.getDay()+SundayIndex;
				if(dayInWeek > 6)
					dayInWeek = dayInWeek-7;
				
				if(nb == 2) {
					formatedDate = formatedDate+DayNames[dayInWeek].substr(0, 3);
				} else if(nb == 4) {
					formatedDate = formatedDate+DayNames[dayInWeek];
				}
			}
			else if(c == 'M')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'M') {
					idx++;
					nb++;
				}
				
				if(nb == 1) {
					formatedDate = formatedDate+(month+1);
				} else if(nb == 2) {
					month = month+1;
					formatedDate = month < 10 ? formatedDate+"0"+month : formatedDate+month;
				} else if(nb == 3) {
					formatedDate = formatedDate+MonthNames[month].substr(0,3);
				} else if(nb == 4) {
					formatedDate = formatedDate+MonthNames[month];
				}
			}
			else if(c == 'y')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'y') {
					idx++;
					nb++;
				}
				
				if(nb == 2) {
					formatedDate = formatedDate+(new String(year).substr(2,2));
				} else if(nb == 4) {
					formatedDate = formatedDate+year;
				}
			}
			else // --- char
			{
				if(c == '\'')
					readingString = true;
				else
					formatedDate = formatedDate+c;
				idx++;
			}
		}
	}
	return formatedDate;
}

function parseDate(dateString, format)
{
	var day = -1;
	var month = -1;
	var year = -1;
	var readingString = false;
	var idx = 0;
	var idxDate = 0;
	while(idx < format.length)
	{
		var c = format.charAt(idx);
		if(readingString)
		{
			if(c == '\'')
				readingString = false;
			else
				if(dateString.charAt(idxDate++) != c) return null;
			idx++;
		}
		else
		{
			if(c == 'd')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'd') {
					idx++;
					nb++;
				}
				
				// --- read day number (1 or 2 chars)
				var v = 0;
				while(idxDate < dateString.length)
				{
					var cd = dateString.charAt(idxDate);
					if(cd < '0' || cd > '9') break;
					v = 10*v+(cd-'0');
					idxDate++;
				}
				if(v == 0) return null;
				day = v;
//alert("Day: "+day);
			}
			else if(c == 'E')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'E') {
					idx++;
					nb++;
				}

				// --- read day name
				// (TODO)
			}
			else if(c == 'M')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'M') {
					idx++;
					nb++;
				}
				
				if(nb <= 2) {
					// --- read month number (1 or 2 chars)
					var v = 0;
					while(idxDate < dateString.length)
					{
						var cd = dateString.charAt(idxDate);
						if(cd < '0' || cd > '9') break;
						v = 10*v+(cd-'0');
						idxDate++;
					}
					if(v == 0) return null;
					month = v-1;
//alert("Month: "+month);
				} else if(nb == 3) {
					// --- read month name (3 chars)
					// (TODO)
				} else if(nb == 4) {
					// --- read full month name
					// (TODO)
				}
			}
			else if(c == 'y')
			{
				var nb = 1;
				idx++;
				while(idx < format.length && format.charAt(idx) == 'y') {
					idx++;
					nb++;
				}
				
				// --- read year number (2 or 4 chars)
				var v = 0;
				var nv = 0;
				while(idxDate < dateString.length)
				{
					var cd = dateString.charAt(idxDate);
					if(cd < '0' || cd > '9') break;
					nv++;
					v = 10*v+(cd-'0');
					idxDate++;
				}
				
				// accept only 2 or 4 digit years, and adjust the range.
				if (nv == 4 && v >= 1000)
				{
					year = v;
				}
				else if (nv == 2 && v < 100)
				{
					// Like SimpleDateFormat, adjust the year between 80 yrs ago to 20 yrs in the future...
					if (v > 25)
						year = 1900 + v;
					else
						year = 2000 + v;
				}
				else
				{
					return null;
				}
//alert("Year: "+year);
			}
			else
			{
				if(c == '\'')
					readingString = true;
				else
					if(dateString.charAt(idxDate++) != c) return null;
				idx++;
			}
		}
	}
	if(idxDate < dateString.length)
		// --- remaining characters into dateString: this is not a date
		return null;
	
	if(month < 0 || month > 11 || year < 0 || day <= 0 || day > getNbOfDays(month, year))
		return null;

	return new Date(year, month, day);
}


/************************************************************************
 * Calendar
 ************************************************************************/
var CalendarPopup = null;
var DateField = null;
var isInCalendar = false;

function postCheckDateFormat(evt, dateField)
{
	var icon = document.images["CALENDAR@"+dateField.name]
	if(!icon)
		return false;
	
	var value = dateField.value;
	if(isNS4 && navigator.platform != "Win32")
	{
		// --- on Unix Netscape 4, value is not yet updated with last char
		value += String.fromCharCode(evt.which);
	}
	
	var date = parseDate(value, CalDateFormat);
	var isValid = (value.length == 0 || date != null);
	icon.src = (isValid? dateOKIconURI: dateKOIconURI);
//alert("postCheckDateFormat ("+dateField.value+"): icon=["+icon+"]");

	return isValid;
}

function postChangeDateField(inputText)
{
	if (inputText.value.length > 0)
	{
		var date = parseDate(inputText.value, CalDateFormat);
		
		// Reformat the date after changing the text in the date field...
		if (date != null)
		{
			var dno = date.getDate();
			var mno = date.getMonth();
			var yno = date.getYear();
			var newdate = formatDate(dno, mno, (yno < 1000? 1900+yno: yno), CalDateFormat);
		
			if (inputText.value != newdate)
				inputText.value = newdate;
		}
	}
}

function fillDateField(formName, dateFieldName, inputData, day, month, year)
{
	var dateFieldObj = document.forms[formName].elements[dateFieldName];
	if(year)
	{
		// --- this is a valid date
		setDate(dateFieldObj, day, month, year);
	}
	else
	{
//		var date = parseDate(inputData, CalDateFormat);
//		var isValid = (inputData.length == 0 || date != null);
//		var icon = document.images["CALENDAR@"+dateFieldName]
//		icon.src = isValid ? dateOKIconURI : dateKOIconURI;
		var icon = document.images["CALENDAR@"+dateFieldName]
		if(inputData == null || inputData.length == 0)
		{
			// --- this is a valid no-date input
			icon.src = dateOKIconURI;
		}
		else
		{
			// --- this is an invalid date
			dateFieldObj.value = inputData;
			icon.src = dateKOIconURI;
		}
	}
}

function setDate(dateFieldObj, day, month, year)
{
	if(dateFieldObj == null)
		return;
	
	var dateStr = day == null ? null : formatDate(day, month, year, CalDateFormat);

	var icon = document.images["CALENDAR@"+dateFieldObj.name];
	if(dateStr != null)
	{
		dateFieldObj.value = dateStr;
		if(icon)
			icon.src = dateOKIconURI;
	}
	else
	{
		dateFieldObj.value = "";
		if(icon)
			icon.src = dateKOIconURI;
	}
}

/*
 * This function initiates a Calendar
 */
function editDate(evt, formName, dateFieldName)
{
	DateField = document.forms[formName].elements[dateFieldName];
	
	var date = parseDate(DateField.value, CalDateFormat);
	if(date == null)
	{
		DateField.value = "";
		date = new Date();
	}
	
/*
	if(CalendarPopup == null)
		CalendarPopup = new PopupWindow();
*/
	if(CalendarPopup != null)
		CalendarPopup.close();
	
	var scrollContainer = getScrollContainer(DateField);
	CalendarPopup = new PopupWindow(scrollContainer);
	displayMonth(date.getDate(), date.getMonth(), date.getFullYear());
//	renderYearCalendar(year);

	// --- compute position
	var srcObj = window.event ? event.srcElement : evt.target;
//	var x = window.event ? event.x : evt.clientX;
//	var y = window.event ? event.y : evt.clientY;
	var buttonPos = getAbsPos(srcObj, scrollContainer);
	var x=buttonPos[0]+2;
	var y=buttonPos[1]+2;
	CalendarPopup.move(x, y);
	CalendarPopup.fitOnScreen(true, true);

//	CalendarPopup.closeOnExit("cleanCalendar()");
	CalendarPopup.closeOnClickOutside("cleanCalendar()");
	CalendarPopup.setVisibility(true);
}

/*
 * This function terminates a Calendar, and fills the Text Input
 * with selected value
 */
function returnDate(day, month, year)
{
//alert("Set Date: "+day+"/"+month+"/"+year);
	setDate(DateField, day, month, year);
	CalendarPopup.close();

	CalendarPopup = null;
	DateField = null;
}

function cleanCalendar()
{
	CalendarPopup.close();
	CalendarPopup = null;
	DateField = null;
}

function displayMonth(day, month, year)
{
	CalendarPopup.setContent(renderMonthCalendar(day, month, year));
}

function frameCell(obj)
{
	if(obj)
		obj.style.borderColor = treeSelectedBackground;
}

function unframeCell(obj)
{
//alert("unframe. bgColor:"+obj.bgColor+" backgroundColor:"+obj.style.backgroundColor+" parent bgColor:"+obj.parentNode.bgColor+" parent borderColor:"+obj.parentNode.style.backgroundColor);
	if(obj)
//		obj.style.borderColor = obj.style.backgroundColor;
		obj.style.borderColor = treeNormalBackground;
}

function setClass(className, obj)
{
	if(obj)
		obj.className = className;
}

function getHTMLCodeForNoDay(dayInWeek)
{
	return "<TD WIDTH='"+DayWidths[dayInWeek]+"%' CLASS=CalWEDay></TD>";
}
function getHTMLCodeForNavButton(label, day, month, year)
{
	return "<TD CLASS=CalNav " +
		" onMouseOver=\"frameCell(this)\"" +
		" onMouseOut=\"unframeCell(this)\"" +
		" onClick=\"displayMonth("+day+", "+month+", "+year+")\"" +
		">" +
		label +
		"</TD>";
}

function getHTMLCodeForDay(dayInWeek, day, month, year, selectedDay)
{
	var SaturdayIndex = SundayIndex + 6;
	if(SaturdayIndex > 6)
		SaturdayIndex = SaturdayIndex - 7;
	var tdClass = day == selectedDay ? "CalSelDay" : ((dayInWeek == SaturdayIndex || dayInWeek == SundayIndex) ? "CalWEDay" : "CalDay");

	var code = "<TD WIDTH='"+DayWidths[dayInWeek]+"%' ALIGN=center CLASS=";
	code = code + tdClass;
	code = code + " onMouseOver=\"setClass('CalSelDay',this)\"";
	code = code + " onMouseOut=\"setClass('"+tdClass+"',this)\"";
	code = code + " onClick=\"returnDate("+day+", "+month+", "+year+");\"";
	code = code + ">";
	code = code + day;
	code = code + "</A></TD>";
	return code;
}

function getHTMLCodeForMonth(day, month, year)
{
	var vCode = "";
	var i;

	vCode += ("<TABLE CLASS=CalMonth WIDTH='100%'>");
	// --- day names
	vCode = vCode + "<TR>";
	for(i=0; i<DayNames.length; i++)
	{
		vCode = vCode + "<TD WIDTH='"+DayWidths[i]+"%' ALIGN=center CLASS=CalDayHeader>";
		vCode = vCode + DayNames[i];
		vCode = vCode + "</TD>";
	}
	vCode = vCode + "</TR>";

	// --- days
	var firstDayDate = new Date(year, month, 1);
	var firstDayInWeek = firstDayDate.getDay()+SundayIndex;
	if(firstDayInWeek > 6)
		firstDayInWeek = firstDayInWeek-7;
	var nbDays = getNbOfDays(month, year);
	if(day > nbDays)
		day = nbDays;

	var curDay = 1-firstDayInWeek;
	while(true)
	{
		vCode = vCode + "<TR>";
		for (i=0; i<7; i++) {
			if(curDay < 1 || curDay > nbDays)
				vCode = vCode + getHTMLCodeForNoDay(i);
			else
				vCode = vCode + getHTMLCodeForDay(i, curDay, month, year, day);
			curDay++;
		}
		vCode = vCode + "</TR>";
		if(curDay > nbDays)
			break;
	}
	
	// --- end of month
	vCode += "</TABLE>";
	
	return vCode;
}

function renderMonthCalendar(day, month, year)
{
	var winContent = "";
	
	winContent = winContent + "<TABLE CLASS=Cal>";

	// --- title: month and year
	// -------------------------
	winContent = winContent + "<TR><TD ALIGN=center COLSPAN=4 CLASS=CalTitle>";
	winContent = winContent +MonthNames[month] + " " + year;
	winContent = winContent + "</TD></TR>";

	// --- navigation
	// --------------
	winContent = winContent + "<TR>";

	// --- prev year
	winContent = winContent + getHTMLCodeForNavButton(CalendarCommands[0], day, month, (year-1));

	// -- prev month
	var prevMonth = month-1;
	var prevYear = year;
	if(month == 0)
	{
		prevMonth = 11;
		prevYear = year-1;
	}
	winContent = winContent + getHTMLCodeForNavButton(CalendarCommands[1], day, prevMonth, prevYear);

	// --- next month
	var nextMonth = month+1;
	var nextYear = year;
	if(month == 11)
	{
		nextMonth = 0;
		nextYear = year+1;
	}
	winContent = winContent + getHTMLCodeForNavButton(CalendarCommands[2], day, nextMonth, nextYear);

	// --- next year
	winContent = winContent + getHTMLCodeForNavButton(CalendarCommands[3], day, month, (year+1));

	winContent = winContent + "</TR>";

	// --- calendar
	// ------------
	var calCode = getHTMLCodeForMonth(day, month, year);
	winContent = winContent + "<TR><TD ALIGN=center COLSPAN=4>";
	winContent = winContent + calCode;
	winContent = winContent + "</TD></TR>";

	winContent = winContent + "</TABLE>";
	
	return winContent;
}

} // --- end of js file load
