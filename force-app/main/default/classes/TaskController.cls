public with sharing class TaskController {
    
    // Method to fetch tasks assigned to the logged-in user
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getUserTasks(String priorityFilter, String statusFilter) {
        String currentUserId = UserInfo.getUserId();
        String query = 'SELECT Id, Name, Description__c, Due_Date__c, Priority__c, Status__c FROM Task__c ' +
                       'WHERE Assigned_To__c = :currentUserId';

        // Filter by Priority if specified
        if (String.isNotBlank(priorityFilter)) {
            query += ' AND Priority__c = :priorityFilter';
        }
        
        // Filter by Status if specified
        if (String.isNotBlank(statusFilter)) {
            query += ' AND Status__c = :statusFilter';
        }

        query += ' ORDER BY Due_Date__c ASC';
        return Database.query(query);
    }

    // Method to create a new task
    @AuraEnabled
    public static Task__c createTask(Task__c newTask) {
        insert newTask;
        return newTask;
    }

    // Method to update the status of a task
    @AuraEnabled
    public static Task__c updateTaskStatus(Id taskId, String newStatus) {
        Task__c taskToUpdate = [SELECT Id, Status__c FROM Task__c WHERE Id = :taskId];
        taskToUpdate.Status__c = newStatus;
        update taskToUpdate;
        return taskToUpdate;
    }

    // Method to delete a task
    @AuraEnabled
    public static void deleteTask(Id taskId) {
        Task__c taskToDelete = [SELECT Id FROM Task__c WHERE Id = :taskId];
        delete taskToDelete;
    }
}
