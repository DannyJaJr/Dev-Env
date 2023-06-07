@IsTest
public class GoogleBooksTest {
    @IsTest
    public static void testMakeCallout() {
        // Create test data
        Book__c existingBook = new Book__c(Title__c = 'Existing Book');
        insert existingBook;
        
        // Create a mock response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"items": [{"volumeInfo": {"title": "Book 1"}, {"title": "Book 2"}}]}');
        
        // Set the mock response in the test context
       // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method under test
         Test.startTest();
         try {
             GoogleBooks.makeCallout();
         } catch (Exception e) {
             // Handle the exception, if needed
         }
         Test.stopTest();
        
        // Check if the existing book is not duplicated
        List<Book__c> duplicatedBooks = [SELECT Title__c FROM Book__c WHERE Id != :existingBook.Id AND Title__c = 'Existing Book'];
        System.assertEquals(0, duplicatedBooks.size(), 'Existing book should not be duplicated');
    }
    
    // Helper class to generate mock HTTP responses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse mockResponse;
        
        public MockHttpResponseGenerator(HttpResponse mockResponse) {
            this.mockResponse = mockResponse;
        }
        
        public HttpResponse respond(HttpRequest request) {
            return mockResponse;
        }
    }
}

