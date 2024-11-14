import { LightningElement, track, wire } from 'lwc';
import getUserTasks from '@salesforce/apex/TaskController.getUserTasks';
import { refreshApex } from '@salesforce/apex';

export default class TaskManager extends LightningElement {
    @track tasks = [];
    @track columns = [
        { label: 'Task Name', fieldName: 'Name', type: 'text' },
        { label: 'Description', fieldName: 'Description__c', type: 'text' },
        { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date' },
        { label: 'Priority', fieldName: 'Priority__c', type: 'picklist' },
        { label: 'Status', fieldName: 'Status__c', type: 'picklist' },
        { type: 'button', typeAttributes: { label: 'Mark Completed', name: 'complete', variant: 'brand' } }
    ];

    // Wired Apex call to fetch tasks
    @wire(getUserTasks, { priorityFilter: '', statusFilter: '' })
    wiredTasks(result) {
        this.tasks = result.data;
        this.error = result.error;
    }

    // Handle create task success
    handleTaskCreated() {
        refreshApex(this.tasks);
    }

    // Handle row action to update task status
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'complete') {
            updateTaskStatus({ taskId: row.Id, newStatus: 'Completed' })
                .then(() => refreshApex(this.tasks));
        }
    }
}
