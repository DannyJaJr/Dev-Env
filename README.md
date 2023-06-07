# Salesforce DX Project: Next Steps

login.salesforce
user: danny.lafontant@wise-bear-ezorzm.com
passord: poiuy0987



## Acces the Salesforce ORG

### Locate the Sales Application from App Launcger
![Sales App](/picture/loginSales.PNG)


### Go under Book check the view list
![Book Obj](/picture/booklistview.PNG)


### Make sure to delete some books. The Apex code prevents duplcation. The HTTP callouts from the endpoint will update all books based on Title
![Delete recs](/picture/deleteBook.PNG)


### Records from A book
![Delete recs](/picture/book.PNG)


### Use the Flow button action, connected to the Apex Class, added inside a flow to call the endpoint. `Update My Library` button calls the endpoint to add all the books from the endpoint without duplication, make sure to delete some books
![Flow Act](/picture/activateFLOW.PNG)

### Check the Flow with the Apex action from the class  [GoogleBook] `GoogleBook`
![Flow](/picture/flow.PNG)
## API endpoint Saved on custom object for security

The 2 classes files contains all the configuration information for this Integration, built with Apex and love [GoogleBooks.cls and GoogleBooksTest.cls]. Danny for more information: danieljajr@gmail.com. Password and loging for testing are provided on Top page



