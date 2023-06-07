public with sharing class GoogleBooks {
 
    @InvocableMethod(label='Update My Library')
    public static void makeCallout(){
        try {
            String endpoint ='https://www.googleapis.com/books/v1/volumes?q=Wolverine%20Worldwide';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setTimeout(120000);

            HttpResponse response = http.send(request);


            if(response.getStatusCode() == 200){
               // System.debug('my data is: ' + response.getBody());

                // Parse the JSON response into a Salesforce-friendly format
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> bookItems = (List<Object>) jsonResponse.get('items');

                // Create a list to store Book records
                List<Book__c> booksToInsert = new List<Book__c>();

                // Iterate over the book items and create Book records
                for (Object bookItem : bookItems) {
                    Map<String, Object> volumeInfo = (Map<String, Object>) ((Map<String, Object>) bookItem).get('volumeInfo');
                    //added for other fields
                    Map<String, Object> saleInfo = (Map<String, Object>)((Map<String, Object>)bookItem).get('saleInfo');
                    Map<String, Object> accessInfo = (Map<String, Object>)((Map<String, Object>)bookItem).get('accessInfo');
                    //Map<String, Object> imageLinks = (Map<String, Object>)((Map<String, Object>)bookItem).get('imageLinks');

                    // Extract the desired fields from volumeInfo
                    String title = (String) volumeInfo.get('title');
                    String subtitle = (String) volumeInfo.get('subtitle');
                    Integer pageCount = (Integer) volumeInfo.get('pageCount');

                                              ///added for other fields
                    String publishedDate = (String)volumeInfo.get('publishedDate');
                    String printType  = (String)volumeInfo.get('printType');
                   // String  smallThumbnail  = (String)imageLinks.get('smallThumbnail');
                    String language   = (String)volumeInfo.get('language');
                   String country  = (String)saleInfo.get('country');
                    String buyLink   = (String)saleInfo.get('buyLink');
                   String webReaderLink  = (String)accessInfo.get('webReaderLink');
                   String previewLink  = (String)volumeInfo.get('previewLink');
                   String infoLink  = (String)volumeInfo.get('infoLink');
    
                    //ends
                   


                    

                    // // Create a new Book record and populate the fields
                    // Book__c book = new Book__c();
                    // book.Title__c = title;
                    // book.Subtitle__c = subtitle;
                    // book.Page_Count__c = pageCount;

                    // // Add the book record to the list
                    // booksToInsert.add(book);
                    // System.debug('my book is: ' + book);

                     // Check if a book with the same title already exists
                     List<Book__c> existingBooks = [SELECT Id FROM Book__c WHERE Title__c = :title LIMIT 1];
                     if (existingBooks.isEmpty()) {
                         // Create a new Book record and populate the fields
                         Book__c book = new Book__c();
                         book.Title__c = title;
                         book.Subtitle__c = subtitle;
                         book.Page_Count__c = pageCount;

                          ///added for other fields
                          //This code checks if the authorsList is not null before iterating over it.
                          List<String> authors = new List<String>();
                          List<Object> authorsList = (List<Object>)volumeInfo.get('authors');
                          if (authorsList != null) {
                              for (Object authorObj : authorsList) {
                                  authors.add((String)authorObj);
                              }
                          }
                          book.Authors__c = String.join(authors, ';');
                    book.Published_Date__c =publishedDate;
                    book.Print_Type__c = printType;
                    //categories
                    List<String> categories = new List<String>();
                          List<Object> categoriesList = (List<Object>)volumeInfo.get('categories');
                          if (categoriesList != null) {
                              for (Object categoriesObj : categoriesList) {
                                categories.add((String)categoriesObj);
                              }
                          }
                          book.Categories__c = String.join(categories, ';');
               //     book.Categories__c = categories;
                  //  book.smallThumbnail__c = smallThumbnail;
                    book.Language__c = language;
                    book.Country__c = country;
                    book.Buy_Link__c = buyLink;
                    book.Download_Link__c = webReaderLink;
                    book.previewLink__c = previewLink;
                    book.infoLink__c = infoLink;
                    // previewLink__c
                    // infoLink__c
                    ///ends
                         
 
                         // Add the book record to the list
                         booksToInsert.add(book);
                     }
                }

                // Insert the book records into Salesforce
                if (!booksToInsert.isEmpty()) {
                    insert booksToInsert;
                }
                System.debug('my booksToInsert is: ' + booksToInsert);
            }
           


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}