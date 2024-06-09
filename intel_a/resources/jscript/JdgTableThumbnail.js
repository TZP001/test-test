// +---------------------------------------------------------------------------
// ! This is Javascript code for JdgTableThumbnail management / Copied by BRH (08/10/2006)
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js

// --- load js file only once
if((typeof LOAD_JdgTableThumbnail_JS) == "undefined") {
LOAD_JdgTableThumbnail_JS = true;

/**
 * Starts loading a 'long load thumbnail'
 */
function JdgTableThumbnail_LoadImg(imgId, imgSrc)
{
	var img = document.getElementById(imgId);
	if(!img)
	{
		alert("Thumbnail image id '"+imgId+"' not found");
		return;
	}
	img.src = imgSrc;
}

} // --- end of js file load

