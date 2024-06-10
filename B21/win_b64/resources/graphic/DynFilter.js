function radio23Click() {
    document.getElementById("FilterText").select();
}

function resetForm() {
    document.getElementById("Radio1").checked = true;
    document.getElementById("FilterText").value = "";
    var a = new Array(document.getElementById("AllTypesChk"),
                      document.getElementById("AllStatChk"),
                      document.getElementById("ClashChk"),
                      document.getElementById("ContactChk"),
                      document.getElementById("ClearanceChk"),
                      document.getElementById("NotInspectedChk"),
                      document.getElementById("RelevantChk"),
                      document.getElementById("IrrelevantChk"));
    for (var i=0; i<a.length; i++) {
        a[i].checked = true;
    }
}

function allChkClick(e) {
    if (e.checked) {
        var coll = e.parentNode.parentNode.parentNode.getElementsByTagName("input");
        if (null != coll) {
            for (var i=1; i<coll.length; i++)
                coll[i].checked = true;
        }
    }
}

function typeChkClick(e) {
    if (!e.checked)
        document.getElementById("AllTypesChk").checked = false;
}

function statChkClick(e) {
    if (!e.checked)
        document.getElementById("AllStatChk").checked = false;
}

function clickBox(e) {
    var coll = e.getElementsByTagName("input");
    if (null != coll) {
        for (var i=0; i<coll.length; i++)
            coll[i].click();
    }
}

function contains(arr, el) {
    for (var i=0; i<arr.length; i++) {
        if (el == arr[i]) return true;
    }
    return false;
}

function getResultTypeCriteria() {
    if (document.getElementById("AllTypesChk").checked)
        return new Array("Clash",
                         "Collision",
                         "Interférence",
                         "Überschneidung",
                         "Interferenza",
                         "Столкновение",
                         "衝突",
                         "충돌",
                         "冲突",
                         "干渉",
                         "Contact",
                         "Contact",
                         "Kontakt",
                         "Contatto",
                         "Контакт",
                         "接触",
                         "접촉",
                         "联络",
                         "Clearance",
                         "Jeu",
                         "Sicherheitsbereich",
                         "Luce minima",
                         "Свободный",
                         "整理",
                         "정리",
                         "清",
                         "ｸﾘｱﾗﾝｽ");
    else {
        var a = new Array();
        if (document.getElementById("ClashChk").checked){
            a.push("Clash");
            a.push("Collision");
            a.push("Interférence");
            a.push("Überschneidung");
            a.push("Interferenza");
            a.push("Столкновение");
            a.push("衝突");
            a.push("충돌");
            a.push("冲突");
            a.push("干渉");
        }
        if (document.getElementById("ContactChk").checked){
            a.push("Contact");
            a.push("Contact");
            a.push("Kontakt");
            a.push("Contatto");
            a.push("Контакт");
            a.push("接触");
            a.push("접촉");
            a.push("联络");
        }
        if (document.getElementById("ClearanceChk").checked){
            a.push("Clearance");
            a.push("Jeu");
            a.push("Sicherheitsbereich");
            a.push("Luce minima");
            a.push("Свободный");
            a.push("整理");
            a.push("정리");
            a.push("清");
            a.push("ｸﾘｱﾗﾝｽ");
        }
        return a;
    }
}

function getClashStatusCriteria() {
    if (document.getElementById("AllStatChk").checked)
        return new Array("Not Inspected",
                         "Non analysé",
                         "Nicht geprüft",
                         "Non esaminata",
                         "Не проверен",
                         "点検されない",
                         "검열하지 않는",
                         "不检查",
                         "未検査",
                         "Relevant",
                         "Pertinent",
                         "Relevant",
                         "Rilevante",
                         "Соответствующие",
                         "関連した",
                         "관련된",
                         "有关",
                         "関係あり",
                         "Irrelevant",
                         "Non pertinent",
                         "Irrelevant",
                         "Non rilevante",
                         "Ненужные",
                         "関係がない",
                         "무관한",
                         "不相干",
                         "無関係");
    else {
        var a = new Array();
        if (document.getElementById("NotInspectedChk").checked){
            a.push("Not Inspected");
            a.push("Non analysé");
            a.push("Nicht geprüft");
            a.push("Non esaminata");
            a.push("Не проверен");
            a.push("点検されない");
            a.push("검열하지 않는");
            a.push("不检查");
            a.push("未検査");
        }
        if (document.getElementById("RelevantChk").checked){
            a.push("Relevant");
            a.push("Pertinent");
            a.push("Relevant");
            a.push("Rilevante");
            a.push("Соответствующие");
            a.push("関連した");
            a.push("관련된");
            a.push("有关");
            a.push("関係あり");        
        }
        if (document.getElementById("IrrelevantChk").checked){
            a.push("Irrelevant");
            a.push("Non pertinent");
            a.push("Irrelevant");
            a.push("Non rilevante");
            a.push("Ненужные");
            a.push("関係がない");
            a.push("무관한");
            a.push("不相干");
            a.push("無関係");
        }
        return a;
    }
}

var clashnb;
var contactnb;
var clearancenb;

function overview(lang) {
    switch(lang) {
    case "japanese":
        return "選択したﾌﾟﾛﾀﾞｸﾄ:" + eval(clashnb+contactnb+clearancenb) + " (干渉: " + clashnb + "､ 接触: " +  contactnb + "､ ｸﾘｱﾗﾝｽ: " + clearancenb + ")";
    case "french":
        return "Produit(s) sélectionné(s): " + eval(clashnb+contactnb+clearancenb) + " (interférence : " + clashnb + ", contact : " + contactnb + ", jeu : " + clearancenb + ")";
    case "german":
        return "Ausgewählte(s) Produkt(e):" + eval(clashnb+contactnb+clearancenb) + " (Überschneidung: " + clashnb + ", Kontakt: " + contactnb + ", Sicherheitsbereich: " + clearancenb + ")";    
    case "italian":
        return "Prodotti selezionati: " + eval(clashnb+contactnb+clearancenb) + " (interferenza: " + clashnb + ", contatto: " + contactnb + ", luce minima: " + clearancenb + ")";
    case "english":
    default:
        return eval(clashnb+contactnb+clearancenb) + " interferences (" + clashnb + " clashes, " +  contactnb + " contacts, " + clearancenb + " clearances)";
    }        
}

function showInterf(row, b) {
    // set the appropriate counter
    var d = b?1:-1;
    var cells = row.childNodes;
    for (var i=0; i<cells.length; i++) {
        if ("ResultType" == cells[i].className) {
            switch (cells[i].firstChild.nodeValue) {
            case "Clash":
            case "Collision":
            case "Interférence":
            case "Überschneidung":
            case "Interferenza":
            case "Столкновение":
            case "衝突":
            case "충돌":
            case "冲突":
            case "干渉":
                clashnb = clashnb + d;
                break;
            case "Contact":
            case "Kontakt":
            case "Contatto":
            case "Контакт":
            case "接触":
            case "접촉":
            case "联络":
                contactnb = contactnb + d;
                break;
            case "Clearance":
            case "Jeu":
            case "Sicherheitsbereich":
            case "Luce minima":
            case "Свободный":
            case "整理":
            case "정리":
            case "清":
                clearancenb = clearancenb + d;
                break;
            }
        }
    }
    // display the interference or not
    var s = "";
    if (!b)
        s = "none";
    row.style.display = s;
    row.nextSibling.style.display = s;
    var e = document.getElementById(row.className);
    if (null != e)
        e.style.display = s;
}

function filter(lang) {
    // retrieve the filter criteria
    var resultType = getResultTypeCriteria();
    if (resultType.length == 0) {
        alert("Select at least one interference type");
        return false;
    }
    var clashStatus = getClashStatusCriteria();
    if (clashStatus.length == 0) {
        alert("Select at least one interference status");
        return false;
    }
    var productFilter = document.getElementById("Radio2").checked;
    var commentsFilter = document.getElementById("Radio3").checked;
    var filterText = document.getElementById("FilterText").value;

    // init counters
    clashnb = 0;
    contactnb = 0;
    clearancenb = 0;
    // retrieve the collection of table rows
    var rows = document.getElementById("ClashTable").childNodes;
    if (null != rows) {

        // for each interference (i=0 is the header row, 2 rows per interference)
        for (var i=1; i<rows.length; i+=2) {
            var row = rows[i];

            // (re)display the row and the description
            showInterf(row, true);

            // retrieve the cells
            var cells = row.childNodes;
            if (null != cells) {
                for (var j=0; j<cells.length; j++) {
                    var cell = cells[j];
                    var c = cell.firstChild; // c is the first HTML or text element of the cell

                    // if we filter on product name
                    if (productFilter && null != c) {
                        if ("ProductName" == c.className) {
                            var x = c.firstChild.nodeValue; // the name of the first product
                            var y;
                            var cells2 = rows[i+1].childNodes;
                            for (var k=0; k<cells2.length; k++) {
                                var c2 = cells2[k].firstChild;
                                if (null != c2) {
                                    if ("ProductName" == c2.className) {
                                        y = c2.firstChild.nodeValue; // the name of the second product
                                        break;
                                    }
                                }
                            }
                            // the regular expression - "i" to ignore case
                            var re = new RegExp(filterText, "i");
                            if (-1 == x.search(re) && -1 == y.search(re)) {
                                showInterf(row, false);
                                break;
                            }
                        }
                    }
                    if ("ResultType" == cell.className) {
                        if (!contains(resultType, c.nodeValue)) {
                            showInterf(row, false);
                            break;
                        }
                    }
                    else if ("ClashStatus" == cell.className) {
                        if (!contains(clashStatus, c.nodeValue)) {
                            showInterf(row, false);
                            break;
                        }
                    }
                    else if ("Comments" == cell.className && commentsFilter) {
                        if (null == c) {
                            showInterf(row, false);
                            break;
                        }
                        // the regular expression - "i" to ignore case
                        var re = new RegExp(filterText, "i");
                        if (-1 == c.nodeValue.search(re)) {
                            showInterf(row, false);
                            break;
                        }
                    }
                }
            }
        }
    }
    document.getElementById("Overview").innerHTML = overview(lang)
}
