@IsTest
public class BookingHelper_Test {

    private static testMethod void testCreateBooking(){
        //TODO : Leverage System.runAs with the profile band managers will ultimately use.
        
        //Insert Songs
        CoverSongTestDataCreator.insertSongs(50);
        
        //Insert other bookings outside the one we're going to test.  This could be converted into a single method call in the test data creator.
        CoverSongTestDataCreator.insertFullBooking();
        CoverSongTestDataCreator.insertFullBooking();
        CoverSongTestDataCreator.insertFullBooking();
        
        Test.startTest();
            Id bookingId = CoverBandTestDataCreator.insertFullBooking();
        Test.stopTest();
        
        //Get the playlist generated.
        Booking__c testBooking = [SELECT Playlist__c FROM Booking__c WHERE Id = :bookingId];
        
        //Assert a playlist was generated.
        System.assertNotEquals(null, testBooking.Playlist__c);
        
        List<SongToPlaylist__c> stp = [SELECT Song__c, Playlist__c FROM SongToPlaylist__c WHERE Playlist__c =: testBooking.Playlist__c];
        
        //Assert the playlist songs were generated
        System.assert(!stp.isEmpty());
        
    }
    
    //TODO : I'd probably add more tests here with exact playlists
    //to check for specific fits, what's in, what's out, etc.
}