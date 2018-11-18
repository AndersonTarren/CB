@IsTest
public class CoverSongTestDataCreator {

    public static void insertSongs(Integer songCount){
        List<Song__c> songs = new List<Song__c>();
        for(Integer i = 0; i < songCount; i++){
            Song__c s = new Song__c();
            s.Name = 'Song ' + i;
            s.Rating__c = String.valueOf(Math.Round(Math.Random()*4+1));
            s.Minutes__c = Math.Round(Math.Random()*4+1);
            s.Seconds__c = Math.Round(Math.Random()*59);
            s.Status__c = CoverSongConstants.SongStatus_Active;
            s.Original_Artist__c = 'Artist ' + i;
            songs.add(s);
        }
        insert songs;
    }
    
    public static Id insertVenue(){
        Venue__c v = new Venue__c();
        v.Name = 'Test Venue';
        insert v;
        return v.Id;
    }
    
    //Insert songs before calling me.
    //Not inserting as a part of this method, as we want bookings to leverage the same lists of songs.
    public static Id insertFullBooking(){
        Id venueId = insertVenue();
        Booking__c b = new Booking__c();
        b.Name = 'Test Booking';
        b.Date__c = DateTime.now();
        b.Duration__c = 60;
        b.Venue__c = venueId;

        insert b;
        return b.Id;
    }
}