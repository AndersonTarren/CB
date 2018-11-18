public class BookingHelper {
    
    //For the purpose of this challenge, I'm going to assume there is only one booking scheduled at a time.
    public static void processBookings(List<Booking__c> bookings){
        if(!bookings.isEmpty()){
            handleBooking(bookings[0]);
        }
    }
    
    private static void handleBooking(Booking__c booking){
        //Get the valid songs for a booking.
        List<Song__c> songs = getSongs(booking.Date__c);
        //Get the duration of each song in seconds.
        Map<Id, Integer> durationMap = getDurations(songs);
        //Get the playlist songs
        Set<Id> playlistIds = getPlaylistIds(songs, (Integer)booking.Duration__c, durationMap);
        Id playlistId = PlaylistHelper.generatePlaylist(playlistIds, booking.Date__c);
        booking.Playlist__c = playlistId;
    }
    
    //Method is a bit long, could be broken up.
    private static List<Song__c> getSongs(DateTime bookingDate){
        
        //Vars we'll need for dates.
        Integer bookingMonth = bookingDate.month();
        Integer bookingYear = bookingDate.year();
        Date d = bookingDate.date();
        Date dateStart = d.toStartOfMonth();
        Date dateEnd = dateStart + Date.daysInMonth(bookingYear, bookingMonth);
        
        //Collections we'll need for processing.
        Set<Id> songBlacklist = new Set<Id>();
        Map<Id, Set<Id>> songCounts = new Map<Id, Set<Id>>();
        //Query junction object
        for(SongToPlaylist__c sp : [SELECT Id, Song__c FROM SongToPlaylist__c WHERE Playlist__r.Date__c >= : dateStart 
                                                                                                                 AND Playlist__r.Date__c <= : dateEnd 
                                                                                                                 AND Song__r.Status__c =: CoverSongConstants.SongStatus_Active]){
            if(!songCounts.containsKey(sp.Song__c)){
                songCounts.put(sp.Song__c, new Set<Id>());
            }    
            songCounts.get(sp.Song__c).add(sp.Id);
        }
        
        
        //Generate Blacklist
        for(Id i : songCounts.keySet()){
            Integer uses = songCounts.get(i).size();
            if(uses >= 3){
                songBlacklist.add(i);
            }
        }
        
        return [SELECT Id, Rating__c, Minutes__c, Seconds__c FROM Song__c WHERE Id NOT IN : songBlacklist AND Status__c =: CoverSongConstants.SongStatus_Active];
    }
    
    //Calculate the duration in seconds based on mins/secs
    //This should be a formula field, but the rules said...
    private static Map<Id, Integer> getDurations(List<Song__c> songs){
        Map<Id, Integer> durations = new Map<Id, Integer>();
        
        for(Song__c s : songs){
            Integer minutes = (Integer)s.Minutes__c;
            Integer seconds = (Integer)s.Seconds__c;
            
            durations.put(s.Id, Integer.valueOf(s.Seconds__c + (60 * s.Minutes__c)));
        }
        
        return durations;
    }
    
    //Taking a simple approach for this challenge only factoring low quality songs.
    //We might, in the future, consider ordering by quality, and always using those first - as well as more complex fitting logic.
    private static Set<Id> getPlaylistIds(List<Song__c> songs, Integer durationMinutes, Map<Id, Integer> durations){
        Set<Id> result = new Set<Id>();
        Integer durationSeconds = durationMinutes * 60;
        Integer playlistDuration = 0;
        Integer lowSongs = 0;
        
        for(Song__c s : songs){
            
            //Low Song Check
            if(Integer.valueOf(s.Rating__c) == 1){
                if(lowSongs >= 3){
                    continue;
                }
                lowSongs++;
            }    
            //Duration Check
            Integer thisDuration = durations.get(s.Id);
            if(thisDuration + playlistDuration <= durationSeconds){
                result.add(s.Id);
                playlistDuration += thisDuration;
            }   
            
            //TODO : Here, we could look at the songs that were skipped due to low quality.  Consider adding them if they fit in the duration.
            //For example, if we ran out of higher quality songs.
        }

        return result;
    }
}