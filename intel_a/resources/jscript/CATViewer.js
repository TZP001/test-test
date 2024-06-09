function VIEWER_createIframe(viewerID, url)
{
  // --- get the marker object
  var marker = document.getElementById(viewerID);
  if (! marker)
    return;
  
  var containerCell = marker.parentNode;
  
  // --- destroy marker
  containerCell.removeChild(marker);
  
  // --- create IFRAME
  var iframe = document.createElement("iframe");
  iframe.border = 0;
  iframe.frameBorder = 0;
  iframe.scrolling = 'no';
  iframe.width = '100%';
  iframe.height = '100%';
  iframe.id = viewerID;
  iframe.src = url;
  containerCell.appendChild(iframe);
}
