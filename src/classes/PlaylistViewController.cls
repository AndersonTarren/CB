public class PlaylistViewController {

    @AuraEnabled
    public static List<Song__c> getPlaylist(Id bookingId){
        if(bookingId == null){
            return null;
        }
        List<Song__c> returnList = new List<Song__c>();
        List<Booking__c> bookings = [SELECT Id, Playlist__c FROM Booking__c WHERE Id = : bookingId LIMIT 1];
        
        if(!bookings.isEmpty()){
            for(SongToPlaylist__c stp : [SELECT Song__r.Name, Song__r.Minutes__c, Song__r.Seconds__c, Song__r.Original_Artist__c FROM SongToPlaylist__c WHERE Playlist__c = : bookings[0].Playlist__c]){
                returnList.add(stp.Song__r);
            }   
        }
        return returnList;
    }
}