//Disclaimer : In prod code, I'd use some kind of trigger pattern,
//like the popular trigger factory.
trigger BookingTrigger on Booking__c (before insert) {
    BookingHelper.processBookings(Trigger.new);
}