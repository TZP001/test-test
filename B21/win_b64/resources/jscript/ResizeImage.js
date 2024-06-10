function resizeImage(image, maxWidth, maxHeight) {
	var wd=Math.min(maxWidth, image.width);
	var ht=Math.min(maxHeight, image.height);
	//if( wd==0 || ht==0 ) alert("Image (width,height) is ("+wd+","+ht+")" );
	if( wd>0 ) image.width=wd;
	if( ht>0 ) image.height=ht;
	image.style.visibility="visible";
}
