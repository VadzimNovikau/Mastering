public class SOQLTask {
    public static void process (){
        //coment1
        //Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта где LastName ‘Leon’
        List<Contact> contactsTask1 = [Select Id, Name, account.Name From Contact Where LastName = '\'Leon\''];
        
        //Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта где LastName будет начинаться с G’
        List<Contact> contactsTask2 = [Select Id, Name, account.Name From Contact Where LastName Like 'G\'%'];
        
        //Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта и отсортировать по LastName(возрастание)
        List<Contact> contactsTask3 = [Select Id, Name, account.Name From Contact Order by LastName ASC];
        
        //Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта где FirstName Godel или LastName Brest
        List<Contact> contactsTask4 = [Select Id, Name, account.Name From Contact Where FirstName = 'Godel' OR LastName = 'Brest'];
        
        //Написать SOQL запрос для получения таблицы из объекта Opportunity с Amount более 200.000
        List<Opportunity> opportunityTask5 = [Select Id From Opportunity Where Amount > 200000];
        
        //Написать SOQL запрос для получения таблицы из объекта Account у которой есть контакты
        List<Account> accountTask6 = [Select Id From Account Where Id IN (Select AccountId From Contact)];
        
        //Написать SOSL запрос, который возвращает Имя и Номер телефона контакта, который содержит в себе код 33.
        List<List<sObject>> searchList = [FIND '%-33-%' IN PHONE FIELDS RETURNING Contact(Name,MobilePhone)];
        
        //Написать SOQL запрос для получения таблицы из объекта Gift с полями Id, Name, а также поле Name связанного с ними User’a
        List<Gift__c> giftTask7 = [Select Id, Name, Gift_Recipient__r.Name From Gift__c];
        
        //Написать SOQL запрос для получения таблицы из объекта Account c полем Name у которой есть контакты, а также поля Id и Name Контактов.
        List<Account> accountTask8 = [Select Id, Name, (Select Id, Name From Contacts) From Account Where Id IN (Select AccountId From Contact)];
        
        //Написать SOQL запрос для получения таблицы из объекта User c полем Name, а также поля Id и Name Gift.
        List<User> accountTask = [Select Id, Name, (Select Id, Name From Gifts__r) From User];

    }

}