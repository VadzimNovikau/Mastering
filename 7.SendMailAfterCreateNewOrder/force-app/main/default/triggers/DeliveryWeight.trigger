trigger DeliveryWeight on Orders__c (before insert, before update, after insert) {
      if (Trigger.isBefore) {
          DeliveryWeightTrHelper.processingWeight(Trigger.new);
      }
      if (Trigger.isafter) {
          DeliveryWeightTrHelper.sendMessageWithOrder(Trigger.new);
      }
}