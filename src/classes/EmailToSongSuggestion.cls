global class EmailToSongSuggestion implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                       Messaging.InboundEnvelope env){
 
    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
  
    String songName, songArtist, songDuration;
    String subject = email.subject;
    
    //Is this subject valid?
    if(String.isBlank(subject)){
        return null;
    }
    
    List<String> songParts = subject.split(',');
    //Have all its parts?  If you're suggesting a song, send me all the info!
    if(songParts.size() != 3){
        return null;
    }
    songName = songParts[0];
    songArtist = songParts[1];
    songDuration = songParts[2].trim();
    
    Map<String, Integer> durationParts = calculateDuration(songDuration);
    if(durationParts == null){
        return null;
    }
    
   
    Song__c song = new Song__c();
    song.Status__c = CoverSongConstants.SongStatus_Proposed;
    song.Name = songName;
    song.Original_Artist__c = songArtist;
    if(durationParts.containsKey('mins') && durationParts.containsKey('secs')){
        song.Minutes__c = durationParts.get('mins');
        song.Seconds__c = durationParts.get('secs');
    }
   
    try {
        insert song;
    }
   catch (QueryException e) {
       System.debug('Song insert went sideways: ' + e);
   }
   
   result.success = true;
   return result;
  }
  
  private Map<String, Integer> calculateDuration(String duration){
      if(String.isBlank(duration)){
          return null;
      }
      List<String> durationParts = duration.split(':');
      if(durationParts.size() != 2){
          return null;
      }
      Map<String, Integer> returnMap = new Map<String, Integer>();
      returnMap.put('mins', Integer.valueOf(durationParts[0]));
      returnMap.put('secs', Integer.valueOf(durationParts[1]));
      return returnMap;
  }
}