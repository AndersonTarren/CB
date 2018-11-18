@IsTest
public class EmailToSongSuggestion_Test {

    private static testMethod void testInboundEmailResult(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        email.subject = 'Test Song,Test Artist,2:34';
        email.fromAddress = 'test@example.com';
        email.plainTextBody = 'Test Body';
        
        Test.startTest();
            EmailToSongSuggestion ess = new EmailToSongSuggestion();
            ess.handleInboundEmail(email, env);
        Test.stopTest();
        
        //Find our new song.
        List<Song__c> songs = [SELECT Id, Name FROM Song__c WHERE Name = 'Test Song' 
                                                            AND Original_Artist__c = 'Test Artist' 
                                                            AND Minutes__c = 2
                                                            AND Seconds__C = 34
                                                            LIMIT 1];
        
        System.assertEquals('Test Song', songs[0].Name);
    }

    private static testMethod void testInboundEmailResultNoSongName(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        email.subject = '';
        email.fromAddress = 'test@example.com';
        email.plainTextBody = 'Test Body';
        
        Test.startTest();
            EmailToSongSuggestion ess = new EmailToSongSuggestion();
            ess.handleInboundEmail(email, env);
        Test.stopTest();
        
        //Find our new song.
        List<Song__c> songs = [SELECT Id, Name FROM Song__c WHERE Name = 'Test Song' LIMIT 1];
        
        System.assert(songs.isEmpty());
    }
    
    private static testMethod void testInboundEmailResultBadDuration(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        email.subject = 'Test Song,Test Artist,2:';
        email.fromAddress = 'test@example.com';
        email.plainTextBody = 'Test Body';
        
        Test.startTest();
            EmailToSongSuggestion ess = new EmailToSongSuggestion();
            ess.handleInboundEmail(email, env);
        Test.stopTest();
        
        //Find our new song.
        List<Song__c> songs = [SELECT Id, Name FROM Song__c WHERE Name = 'Test Song' LIMIT 1];
        
        System.assert(songs.isEmpty());
    }
}