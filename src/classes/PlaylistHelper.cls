public class PlaylistHelper {

    public static Id generatePlaylist(Set<Id> songIds, DateTime thisDate){
        Playlist__c p = new Playlist__c();
        p.Date__c = thisDate;
        insert p;
        
        List<SongToPlaylist__c> songs = new List<SongToPlaylist__c>();
        for(Id i : songIds){
            SongToPlaylist__c stp = new SongToPlaylist__c();
            stp.Song__c = i;
            stp.Playlist__c = p.Id;
            songs.add(stp);
        }
        insert songs;
        
        return p.Id;
    }
}