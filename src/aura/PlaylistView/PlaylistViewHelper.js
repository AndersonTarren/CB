({
	processDuration : function(cmp, songs) {
	    var mins = 0;
	    var secs = 0;
        songs.forEach(function(s){
            s.Duration = s.Minutes__c + ':' + (s.Seconds__c < 10 ? '0' : '') + s.Seconds__c;
            mins += parseInt(s.Minutes__c);
            secs += parseInt(s.Seconds__c);
        });
        
        cmp.set('v.playlistData', songs);
        this.processTotalDuration(cmp, mins, secs);
	},
	
	processTotalDuration : function(cmp, mins, secs){
	    var totalSeconds = mins * 60 + secs;
	    var minutes = Math.floor(totalSeconds / 60);
	    var seconds = totalSeconds - minutes * 60;
	    var result = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
	    cmp.set('v.duration', result);
	}
})