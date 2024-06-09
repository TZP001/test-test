from com.ibm.websphere.product import WASProduct
WASProduct = WASProduct()
products = WASProduct.getProducts()
while(products.hasNext()):
	product = products.next()
	print "Name="+product.getName()
	print "Id="+product.getId()
	print "Version="+product.getVersion()
#
