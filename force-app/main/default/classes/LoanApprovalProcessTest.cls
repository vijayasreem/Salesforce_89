
@IsTest
public class LoanApprovalProcessTest {
    
    @IsTest
    static void testEvaluateLoanApplication_DocumentsVerifiedCreditworthy() {
        // Test data setup
        String customerId = '001';
        
        // Mocking the verifyDocuments method
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean documentsVerified = true;
        LoanApprovalProcess.verifyDocuments(customerId);
        Test.stopTest();
        
        // Mocking the assessCreditworthiness method
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean creditworthy = true;
        LoanApprovalProcess.assessCreditworthiness(customerId);
        Test.stopTest();
        
        // Test the evaluateLoanApplication method
        Test.startTest();
        LoanApprovalNotification notification = LoanApprovalProcess.evaluateLoanApplication(customerId);
        Test.stopTest();
        
        // Verify the loan approval notification values
        System.assertEquals(50000, notification.getLoanAmount());
        System.assertEquals(5.5, notification.getInterestRate());
        System.assertEquals(60, notification.getRepaymentPeriod());
        System.assertEquals('Provide collateral', notification.getAdditionalRequirements());
        System.assertEquals(null, notification.getRejectionMessage());
    }
    
    @IsTest
    static void testEvaluateLoanApplication_DocumentsNotVerified() {
        // Test data setup
        String customerId = '001';
        
        // Mocking the verifyDocuments method
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean documentsVerified = false;
        LoanApprovalProcess.verifyDocuments(customerId);
        Test.stopTest();
        
        // Mocking the assessCreditworthiness method
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean creditworthy = true;
        LoanApprovalProcess.assessCreditworthiness(customerId);
        Test.stopTest();
        
        // Test the evaluateLoanApplication method
        Test.startTest();
        LoanApprovalNotification notification = LoanApprovalProcess.evaluateLoanApplication(customerId);
        Test.stopTest();
        
        // Verify the rejection message in the loan approval notification
        System.assertEquals('Insufficient documents or low creditworthiness', notification.getRejectionMessage());
        System.assertEquals(null, notification.getLoanAmount());
        System.assertEquals(null, notification.getInterestRate());
        System.assertEquals(null, notification.getRepaymentPeriod());
        System.assertEquals(null, notification.getAdditionalRequirements());
    }
    
    @IsTest
    static void testEvaluateLoanApplication_NotCreditworthy() {
        // Test data setup
        String customerId = '001';
        
        // Mocking the verifyDocuments method
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean documentsVerified = true;
        LoanApprovalProcess.verifyDocuments(customerId);
        Test.stopTest();
        
        // Mocking the assessCreditworthiness method
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean creditworthy = false;
        LoanApprovalProcess.assessCreditworthiness(customerId);
        Test.stopTest();
        
        // Test the evaluateLoanApplication method
        Test.startTest();
        LoanApprovalNotification notification = LoanApprovalProcess.evaluateLoanApplication(customerId);
        Test.stopTest();
        
        // Verify the rejection message in the loan approval notification
        System.assertEquals('Insufficient documents or low creditworthiness', notification.getRejectionMessage());
        System.assertEquals(null, notification.getLoanAmount());
        System.assertEquals(null, notification.getInterestRate());
        System.assertEquals(null, notification.getRepaymentPeriod());
        System.assertEquals(null, notification.getAdditionalRequirements());
    }
    
    // Mock HTTP callout response class
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('Mock response');
            return res;
        }
    }
    
}
