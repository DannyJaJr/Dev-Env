public with sharing class GoogleBooks {
 
    @AuraEnabled
    public static void makeCallout(){
        try {
            String endpoint ='https://www.googleapis.com/books/v1/volumes?q=Wolverine%20Worldwide';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setTimeout(120000);

            HttpResponse response = http.send(request);

            // if(response.getStatusCode() == 200){
            //     System.debug('my data is: ' + response.getBody());
            // }


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

                    // Extract the desired fields from volumeInfo
                    String title = (String) volumeInfo.get('title');
                    String subtitle = (String) volumeInfo.get('subtitle');
                    Integer pageCount = (Integer) volumeInfo.get('pageCount');

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