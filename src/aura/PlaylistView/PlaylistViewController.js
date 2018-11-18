({
	doInit : function(cmp, event, helper) {
	   cmp.set('v.columns', [
            {label: 'Song Name', fieldName: 'Name', type: 'text'},
            {label: 'Artist', fieldName: 'Original_Artist__c', type: 'text'},
            {label: 'Duration', fieldName: 'Duration', type: 'text'}
        ]);
        var action = cmp.get("c.getPlaylist");
        action.setParams({ bookingId : cmp.get("v.recordId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.processDuration(cmp, response.getReturnValue());
            }

            else if (state === "ERROR") {
                //TODO : Error handling
            }
        });
        $A.enqueueAction(action);
	}
})