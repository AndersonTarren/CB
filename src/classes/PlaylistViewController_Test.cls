@IsTest
public class PlaylistViewController_Test {

    private static testMethod void testGetPlaylist(){
        
        CoverSongTestDataCreator.insertSongs(50);
        Id bookingId = CoverSongTestDataCreator.insertFullBooking();
        
        Test.startTest();
            List<Song__c> songs = PlaylistViewController.getPlaylist(bookingId);
        Test.stopTest();
        
        System.assert(!songs.isEmpty());
    }

    private static testMethod void testGetPlaylistWithNull(){
        
        CoverSongTestDataCreator.insertSongs(50);

        Test.startTest();
            List<Song__c> songs = PlaylistViewController.getPlaylist(null);
        Test.stopTest();
        
        System.assertEquals(null, songs);
    }
}
