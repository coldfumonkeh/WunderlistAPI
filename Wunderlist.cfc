component accessors="true"{
	
	property name="clientId"		type="string";
	property name="clientSecret"	type="string";
	property name="accessToken"		type="string";
	property name="baseURL" 		type="string" default="https://a.wunderlist.com/api/v1/";
	property name="JSONUtil"		type="any";
	
	
	/**
	* Constructor method
	* @clientId The client id for your app
	* @clientSecret The client secret for your app
	* @accessToken Your access token value
	* @baseURL The API base URL, if it changes from the default.
	*/
	public Wunderlist function init(
		required string clientId,
		required string clientSecret,
		string accessToken,
		string baseURL
	){
		setClientId( arguments.clientId );
		setClientSecret( arguments.clientSecret );
		if( len( arguments.accessToken ) ){
			setAccessToken( arguments.accessToken );
		}
		if( len( arguments.baseURL ) ){
			setBaseURL( arguments.baseURL );
		}
		setJSONUtil( new JsonSerializer() );
		return this;
	}
	
	/*****************************************
	*                AVATAR                  *
	*****************************************/

	/**
	* Show the avatar of a user
	* @user_id The user id
	* @size values: 25, 28, 30, 32, 50, 54, 56, 60, 64, 108, 128, 135, 256, 270, 512 and original
	* @fallback By adding the optional parameter fallback with the value false to the request, you will not be redirected to our fallback avatars. If there is no custom avatar uploaded for the given user_id it will respond with a 204 No Content and an empty body.
	*/
	public function avatar(
		required numeric user_id,
		numeric size,
		boolean fallback,
		boolean deserialize
	){
		var strURL = 'avatar?user_id=' & arguments.user_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize, accessTokenRequired=false ); 
	}
	
	/*****************************************
	*                 FILE                   *
	*****************************************/
	
	/**
	* Get Files for a Task or List
	* @task_id The task id
	* @list_id The list id
	*/
	public function getFiles(
		numeric task_id,
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'files';
		if( !len( arguments.task_id ) && !len( arguments.list_id ) ){
			throw( message='You must provide a task_id or list_id' );
			abort;
		}
		if( len( arguments.task_id ) ){
			strURL = strURL & '?task_id=' & arguments.task_id;
		} else if( len( arguments.list_id ) ){
			strURL = strURL & '?list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get a specific File
	* @file_id The file id
	*/
	public function getFile(
		numeric file_id,
		boolean deserialize
	){
		var strURL = 'files/' & arguments.file_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/*****************************************
	*               FOLDER                   *
	*****************************************/
	
	/**
	* Get all Folders created by the the current User
	*/
	public function getFolders(
		boolean deserialize
	){
		var strURL = 'folders';
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get a specific Folder
	* @folder_id The folder id
	*/
	public function getFolder(
		required numeric folder_id,
		boolean deserialize
	){
		var strURL = 'folders/' & arguments.folder_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Create a Folder
	* @title The folder title. Maximum length is 255 characters
	* @list_ids A comma-separated list of list ids to place within the folder
	*/
	public function createFolder(
		required string title,
		required string list_ids,
		boolean deserialize
	){
		var strURL = 'folders';
		var sBody = {
			'title': arguments.title,
			'list_ids': listToArray( arguments.list_ids )
		};
		
		var serializer = getJSONUtil()
	        .asInteger( "list_ids" );
	        
		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Update a Folder by overwriting properties
	* @folder_id The folder id
	* @revision The revision number
	* @title The folder title. Maximum length is 255 characters
	* @list_ids A comma-separated list of list ids to place within the folder
	*/
	public function updateFolder(
		required numeric folder_id,
		required numeric revision,
		string title,
		string list_ids,
		boolean deserialize
	){
		var strURL = 'folders/' & arguments.folder_id;
		var sBody = {
			'folder_id': arguments.folder_id,
			'revision': arguments.revision,
			'list_ids': listToArray( arguments.list_ids )
		};
		if( len( arguments.title ) ){
			structInsert( sBody, 'title', arguments.title );
		}
		if( len( arguments.list_ids ) ){
			structInsert( sBody, 'list_ids', listToArray( arguments.list_ids ) );
		}
		
		var serializer = getJSONUtil()
	        .asInteger( "folder_id" )
	        .asInteger( "revision" )
	        .asInteger( "list_ids" );
	        
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get Folder Revisions
	*/
	public function getFolderRevisions(
		boolean deserialize
	){
		var strURL = 'folder_revisions';
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Delete a Folder permanently
	* @folder_id The folder id
	* @revision The revision number
	*/
	public function deleteFolder(
		required numeric folder_id,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'folders/' & arguments.folder_id & '?revision=' & arguments.revision;
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize ); 
	}

	/*****************************************
	*                LIST                    *
	*****************************************/

	/**
	* Get all Lists a user has permission to
	*/
	public function getLists(
		boolean deserialize
	){
		var strURL = 'lists';
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get a specific list
	* @list_id The list id
	*/
	public function getList(
		required numeric list_id,
		boolean deserialize
	){
		var strURL = 'lists/' & arguments.list_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Create a list
	*/
	public function createList(
		required string title,
		boolean deserialize
	){
		var strURL = 'lists';
		var sBody = {
			'title': arguments.title
		};		
		return makeRequest( method='POST', url=strURL, body=serializeJSON( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Update a list by overwriting properties
	* @list_id The list id
	* @revision The revision number
	* @title The title
	*/
	public function updateList(
		required numeric list_id,
		required numeric revision,
		required string title,
		boolean deserialize
	){
		var strURL = 'lists/' & arguments.list_id & '?revision=' & arguments.revision;			
		var sBody = {
			'revision': arguments.revision,
			'title': arguments.title
		};
		return makeRequest( method='PATCH', url=strURL, body=serializeJSON( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Delete a list permanently
	* @list_id The list id
	* @revision The revision number
	*/
	public function deleteList(
		required numeric list_id,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'lists/' & arguments.list_id & '?revision=' & arguments.revision;
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/*****************************************
	*              MEMBERSHIP                *
	*****************************************/
	
	/**
	* Get Memberships for a List or the current User
	*/
	public function getMembership(
		boolean deserialize
	){
		var strURL = 'memberships';
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Add a Member to a List
	* @list_id The list id
	* @user_id The user id
	* @email The user email
	* @muted 
	*/
	public function addMemberToList(
		required numeric list_id,
		numeric user_id,
		string email,
		boolean muted = false,
		boolean deserialize
	){
		var strURL = 'memberships';
		
		if( !len( arguments.user_id ) && !len( arguments.email ) ) {
			throw( message='You must provide either a user_id or email' );
			abort;
		}
		
		var sBody = {
			'list_id': arguments.list_id,
			'muted': arguments.muted
		};
		
		if( len( arguments.user_id ) ){
			structInsert( sBody, 'user_id', arguments.user_id );
		}
		if( len( arguments.email ) ){
			structInsert( sBody, 'email', arguments.email );
		}
		
		var serializer = getJSONUtil()
	        .asInteger( "list_id" )
	        .asInteger( "user_id" )
	        .asBoolean( "muted" );

		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Mark a Member as accepted - must be performed by the recipient of the invitation
	* @membership_id The membership id
	* @revision The revision number
	* @state The state of the membership. Defaults to 'accepted'.
	* @muted
	*/
	public function acceptMember(
		required numeric membership_id,
		required numeric revision,
		required string state = 'accepted',
		boolean muted,
		boolean deserialize
	){
		var strURL = 'memberships/' & arguments.membership_id;
		var sBody = {
			'membership_id': arguments.membership_id,
			'revision': arguments.revision,
			'state': arguments.state
		};
		
		if( len( arguments.muted ) ){
			structInsert( sBody, 'muted', arguments.muted );
		}
		
		var serializer = getJSONUtil()
	        .asInteger( "membership_id" )
	        .asInteger( "revision" )
	        .asBoolean( "muted" );

		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Remove a Member from a List
	* @membership_id The membership id
	* @revision The revision number
	*/
	public function deleteMember(
		required numeric membership_id,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'memberships/' & arguments.membership_id & '?revision=' & arguments.revision;
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/*****************************************
	*                NOTE                    *
	*****************************************/
	
	/**
	* Get the Notes for a Task or List
	* @task_id The task id
	* @list_id The list id
	*/
	public function getNotes(
		numeric task_id,
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'notes';
		if( !len( arguments.task_id ) && !len( arguments.list_id ) ){
			throw( message='You must provide a task_id or list_id' );
			abort;
		}
		if( len( arguments.task_id ) ){
			strURL = strURL & '?task_id=' & arguments.task_id;
		} else if( len( arguments.list_id ) ){
			strURL = strURL & '?list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get a specific note
	* @note_id The note id
	*/
	public function getNote(
		required numeric note_id,
		boolean deserialize
	){
		var strURL = 'notes/' & arguments.note_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Create a note
	* @task_id The task id
	* @content The task content
	*/
	public function createNote(
		required numeric task_id,
		required string content,
		boolean deserialize
	){
		var strURL = 'notes';
		var sBody = {
			'task_id': arguments.task_id,
			'content': arguments.content
		};
		var serializer = getJSONUtil()
	        .asInteger( "task_id" );
	        
		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Update a note by overwriting properties
	* @note_id The note id
	* @revision The revision number
	* @content The note content
	*/
	public function updateNote(
		required numeric note_id,
		required numeric revision,
		required string content,
		boolean deserialize
	){
		var strURL = 'notes/' & arguments.note_id;
		var sBody = {
			'note_id': arguments.note_id,
			'revision': arguments.revision,
			'content': arguments.content
		};
		var serializer = getJSONUtil()
	        .asInteger( "note_id" )
	        .asInteger( "revision" );
	        
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Delete a note
	* @note_id The note id
	* @revision The revision number
	*/
	public function deleteNote(
		required numeric note_id,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'notes/' & arguments.note_id & '?revision=' & arguments.revision;
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize );
	}
	
	
	/*****************************************
	*               POSITIONS                *
	*****************************************/
	
	/**
	* Get Positions for a user's lists
	*/
	public function getListPositions(
		boolean deserialize
	){
		var strURL = 'list_positions';
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Get a specific list position
	* @list_id The list id
	*/
	public function getListPosition(
		required numeric list_id,
		boolean deserialize
	){
		var strURL = 'list_positions/' & arguments.list_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Update Positions for a user's lists
	* @list_id The list id
	* @values a comma-separated list of values
	* @revision The revision number
	*/
	public function updateListPositions(
		required numeric list_id,
		required string values,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'list_positions/' & arguments.list_id;
		var sBody = {
			'values': listToArray( arguments.values ),
			'revision': arguments.content
		};
		var serializer = getJSONUtil()
	        .asInteger( "values" )
	        .asInteger( "revision" );
	        
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get Positions for a list's tasks
	* @list_id The list id
	*/
	public function getTaskPositions(
		required numeric list_id,
		boolean deserialize
	){
		var strURL = 'task_positions?list_id=' & arguments.list_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Get a specific task position
	* @task_id The task id
	*/
	public function getTaskPosition(
		required numeric task_id,
		boolean deserialize
	){
		var strURL = 'task_positions/' & arguments.task_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Update Positions for a list's tasks
	* @task_id The task id
	* @values a comma-separated list of values
	* @revision The revision number
	*/
	public function updateTaskPositions(
		required numeric task_id,
		required string values,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'task_positions/' & arguments.task_id;
		var sBody = {
			'values': listToArray( arguments.values ),
			'revision': arguments.content
		};
		var serializer = getJSONUtil()
	        .asInteger( "values" )
	        .asInteger( "revision" );
	        
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get Positions for a tasks's subtasks
	* @task_id The task id
	* @list_id The list id
	*/
	public function getSubtaskPositions(
		numeric task_id,
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'subtask_positions';
		if( !len( arguments.task_id) && !len( arguments.list_id) ){
			throw( message='You must provide either a task_id or list_id' );
			abort;
		}
		if( len( arguments.task_id ) ){
			strURL = strURL & '?task_id=' & arguments.task_id;
		} else if( len( arguments.task_id ) ){
			strURL = strURL & '?list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Get a specific subtask position
	* @subtask_id The subtask id
	*/
	public function getSubtaskPosition(
		required numeric subtask_id,
		boolean deserialize
	){
		var strURL = 'subtask_positions/' & arguments.subtask_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Update Positions for a task's subtasks
	* @subtask_id The subtask id
	* @values a comma-separated list of values
	* @revision The revision number
	*/
	public function updateSubtaskPositions(
		required numeric subtask_id,
		required string values,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'task_positions/' & arguments.subtask_id;
		var sBody = {
			'values': listToArray( arguments.values ),
			'revision': arguments.content
		};
		var serializer = getJSONUtil()
	        .asInteger( "values" )
	        .asInteger( "revision" );
	        
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize ); 
	}
	
	/*****************************************
	*              REMINDER                  *
	*****************************************/
	
	/**
	* Get Reminders for a Task or List
	* @task_id The task id
	* @list_id The list id
	*/
	public function getReminders(
		numeric task_id,
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'reminders';
		if( !len( arguments.task_id) && !len( arguments.list_id) ){
			throw( message='You must provide either a task_id or list_id' );
			abort;
		}
		if( len( arguments.task_id ) ){
			strURL = strURL & '?task_id=' & arguments.task_id;
		} else if( len( arguments.task_id ) ){
			strURL = strURL & '?list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Create a Reminder
	* @task_id The task id
	* @date The date
	* @created_by_device_udid
	*/
	public function createReminder(
		required numeric task_id,
		required string date,
		string created_by_device_udid = '',
		boolean deserialize
	){
		var strURL = 'reminders';
		var sBody = {
			'task_id': arguments.task_id,
			'date': arguments.date,
			'created_by_device_udid': arguments.created_by_device_udid
		};
		
		var serializer = getJSONUtil()
	        .asInteger( "task_id" );
		
		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}
	
	/**
	* Update a Reminder
	* @reminder_id The reminder id
	* @date The date
	* @created_by_device_udid
	*/
	public function updateReminder(
		required numeric reminder_id,
		required string date,
		string created_by_device_udid = '',
		boolean deserialize
	){
		var strURL = 'reminders/' & arguments.reminder_id;
		var sBody = {
			'id': arguments.reminder_id,
			'date': arguments.date,
			'created_by_device_udid': arguments.created_by_device_udid
		};
		
		var serializer = getJSONUtil()
	        .asInteger( "reminder_id" );
		
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}
	
	/**
	* Delete a Reminder
	* @reminder_id The reminder id
	*/
	public function deleteReminder(
		required numeric reminder_id,
		boolean deserialize
	){
		var strURL = 'reminders/' & arguments.reminder_id;
		
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize );
	}

	/*****************************************
	*                ROOT                    *
	*****************************************/
	
	/**
	* Fetch the Root for the current User
	*/
	public function getRoot(
		boolean deserialize
	){
		var strURL = 'root';
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}

	/*****************************************
	*               SUBTASK                  *
	*****************************************/
	
	/**
	* Get Subtasks for a Task or List
	* @task_id The task id
	* @list_id The list id
	*/
	public function getSubtasks(
		numeric task_id,
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'subtasks';
		if( !len( arguments.task_id) && !len( arguments.list_id) ){
			throw( message='You must provide either a task_id or list_id' );
			abort;
		}
		if( len( arguments.task_id ) ){
			strURL = strURL & '?task_id=' & arguments.task_id;
		} else if( len( arguments.task_id ) ){
			strURL = strURL & '?list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get Completed Subtasks for a Task or List
	* @task_id The task id
	* @list_id The list id
	*/
	public function getCompletedSubtasks(
		numeric task_id,
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'subtasks';
		if( !len( arguments.task_id) && !len( arguments.list_id) ){
			throw( message='You must provide either a task_id or list_id' );
			abort;
		}
		if( len( arguments.task_id ) ){
			strURL = strURL & '?completed=true&task_id=' & arguments.task_id;
		} else if( len( arguments.task_id ) ){
			strURL = strURL & '?completed=true&list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get a specific subtask
	* @subtask_id The subtask id
	*/
	public function getSubtask(
		required numeric subtask_id,
		boolean deserialize
	){
		var strURL = 'subtasks/' & arguments.subtask_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Create a subtask
	* @task_id The task id
	* @title The subtask title
	* @completed Is the task completed?
	*/
	public function createSubtask(
		required numeric task_id,
		required string title,
		boolean completed = false,
		boolean deserialize
	){
		var strURL = 'subtasks';
		var sBody = {
			'task_id': arguments.task_id,
			'title': arguments.title,
			'completed': arguments.completed
		};
		
		var serializer = getJSONUtil()
	        .asInteger( "task_id" )
	        .asBoolean( "completed" );
		
		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}
	
	/**
	* Update a subtask by overwriting properties
	* @subtask_id The subtask id
	* @revision The revision number
	* @title maximum length is 255
	* @completed Is the task completed?
	*/
	public function updateSubtask(
		required numeric subtask_id,
		required numeric revision,
		required string title,
		boolean completed,
		boolean deserialize
	){
		var strURL = 'subtasks/' & arguments.subtask_id;
		var sBody = {
			'subtask_id': arguments.subtask_id,
			'revision': arguments.revision,
			'completed': arguments.completed
		};
		
		var serializer = getJSONUtil()
	        .asInteger( "subtask_id" )
	        .asInteger( "revision" )
	        .asBoolean( "completed" );
		
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}

	/**
	* De;ete a subtask
	* @subtask_id The subtask id
	*/
	public function deleteSubtask(
		required numeric subtask_id,
		boolean deserialize
	){
		var strURL = 'subtasks/' & arguments.subtask_id;
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize );
	}

	/*****************************************
	*                TASK                    *
	*****************************************/
	
	/**
	* Get Tasks for a List
	* @list_id The list id
	*/
	public function getTasks(
		required numeric list_id,
		boolean deserialize
	){
		var strURL = 'tasks?list_id=' & arguments.list_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get Completed Tasks from a List
	* @list_id The list id
	*/
	public function getCompletedTasks(
		required numeric list_id,
		boolean deserialize
	){
		return getTaskByState( list_id=arguments.list_id, completed=true, deserialize=arguments.deserialize );
	}
	
	/**
	* Get Incomplete Tasks from a List
	* @list_id The list id
	*/
	public function getIncompleteTasks(
		required numeric list_id,
		boolean deserialize
	){
		return getTaskByState( list_id=arguments.list_id, completed=false, deserialize=arguments.deserialize );
	}
	
	/**
	* Manages the complete / incomplete data retrieval
	* @list_id The list id
	* @completed true or false
	*/
	private function getTaskByState(
		required numeric list_id,
		required boolean completed,
		boolean deserialize
	){
		var strURL = 'tasks?list_id=' & arguments.list_id & '&completed=' & arguments.completed;
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Get a specific Task
	* @task_id The task id
	*/
	public function getTask(
		required numeric task_id,
		boolean deserialize
	){
		var strURL = 'tasks/' & arguments.task_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Create a Task
	* @list_id The list id
	* @title The task title
	* @assignee_id The id of the user to be assigned to the task
	* @completed Is the task completed?
	* @recurrence_type valid options: "day", "week", "month", "year", must be accompanied by recurrence_count
	* @recurrence_count must be >= 1, must be accompanied by recurrence_type
	* @due_date formatted as an ISO8601 date
	* @starred boolean Is the task starred?
	*/
	public function createTask(
		required numeric list_id,
		required string title,
		numeric assignee_id,
		boolean completed = false,
		string recurrence_type,
		numeric recurrence_count,
		string due_date,
		boolean starred = false,
		boolean deserialize
	){
		var strURL = 'tasks';
		var sBody = {
			'list_id': arguments.list_id,
			'title': arguments.title,
			'completed': arguments.completed,
			'starred': arguments.starred
		};
		if( len( arguments.assignee_id ) ){
			structInsert( sBody, 'assignee_id', arguments.assignee_id );
		}
		if( len( arguments.recurrence_type ) ){
			structInsert( sBody, 'recurrence_type', arguments.recurrence_type );
		}
		if( len( arguments.recurrence_count ) ){
			structInsert( sBody, 'recurrence_count', arguments.recurrence_count );
		}
		if( len( arguments.due_date ) ){
			structInsert( sBody, 'assigdue_datenee_id', arguments.due_date );
		}
		
		var serializer = getJSONUtil()
	        .asInteger( "list_id" )
	        .asBoolean( "completed" )
	        .asBoolean( "starred" )
	        .asInteger( "assignee_id" );
		
		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}
	
	/**
	* Update a Task by overwriting properties
	* @task_id The task id
	* @revision The revision number
	* @list_id The list id
	* @title The task title
	* @assignee_id The id of the user to be assigned to the task
	* @completed Is the task completed?
	* @recurrence_type valid options: "day", "week", "month", "year", must be accompanied by recurrence_count
	* @recurrence_count must be >= 1, must be accompanied by recurrence_type
	* @due_date formatted as an ISO8601 date
	* @starred boolean Is the task starred?
	* @remove a comma-separated list of attributes to delete from the task, e.g. 'due_date'
	*/
	public function updateTask(
		required numeric task_id,
		required numeric revision,
		numeric list_id,
		string title,
		numeric assignee_id,
		boolean completed,
		string recurrence_type,
		numeric recurrence_count,
		string due_date,
		boolean starred,
		string remove,
		boolean deserialize
	){
		var strURL = 'tasks/' & arguments.task_id;
		var sBody = {
			'task_id': arguments.task_id,
			'revision': arguments.revision
		};
		if( len( arguments.list_id ) ){
			structInsert( sBody, 'list_id', arguments.list_id );
		}
		if( len( arguments.title ) ){
			structInsert( sBody, 'title', arguments.title );
		}
		if( len( arguments.assignee_id ) ){
			structInsert( sBody, 'assignee_id', arguments.assignee_id );
		}
		if( len( arguments.completed ) ){
			structInsert( sBody, 'completed', arguments.completed );
		}
		if( len( arguments.recurrence_type ) ){
			structInsert( sBody, 'recurrence_type', arguments.recurrence_type );
		}
		if( len( arguments.recurrence_count ) ){
			structInsert( sBody, 'recurrence_count', arguments.recurrence_count );
		}
		if( len( arguments.due_date ) ){
			structInsert( sBody, 'due_date', arguments.due_date );
		}
		if( len( arguments.starred ) ){
			structInsert( sBody, 'starred', arguments.starred );
		}
		if( len( arguments.remove ) ){
			structInsert( sBody, 'remove', arguments.remove );
		}
		
		var serializer = getJSONUtil()
	        .asInteger( "task_id" )
	        .asInteger( "revision" )
	        .asInteger( "list_id" )
	        .asInteger( "assignee_id" )
	        .asBoolean( "completed" )
	        .asBoolean( "starred" )
	        .asInteger( "recurrence_count" );

		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}
	
	
	/**
	* Delete a task
	* @task_id The task id
	* @revision The revision number
	*/
	public function deleteTask(
		required numeric task_id,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'tasks/' & arguments.task_id & '?revision=' & arguments.revision;
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize ); 
	}

	/*****************************************
	*             TASK COMMENT               *
	*****************************************/
	
	/**
	* Get the Comments for a Task or List
	* @task_id The task id
	* @list_id The list id
	*/
	public function getComments(
		numeric task_id,
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'task_comments';
		if( !len( arguments.task_id) && !len( arguments.list_id) ){
			throw( message='You must provide either a task_id or list_id' );
			abort;
		}
		if( len( arguments.task_id ) ){
			strURL = strURL & '?task_id=' & arguments.task_id;
		} else if( len( arguments.task_id ) ){
			strURL = strURL & '?list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Get a specific Comment
	* @comment_id The comment id
	* @list_id The list id
	*/
	public function getComment(
		numeric comment_id,
		boolean deserialize
	){
		var strURL = 'task_comments/' & arguments.comment_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/**
	* Create a Comment
	* @task_id The task id
	* @text The comment text
	*/
	public function createComment(
		required numeric task_id,
		required string text,
		boolean deserialize
	){
		var strURL = 'task_comments';
		var sBody = {
			'task_id': arguments.task_id,
			'text': arguments.text
		};
		
		var serializer = getJSONUtil()
	        .asInteger( "task_id" );
		
		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}

	/*****************************************
	*                UPLOAD                  *
	*****************************************/
	
	/**
	* Create a new upload
	* @content_type The content type of the uploaded file
	* @file_name The file name
	* @file_size The file size
	* @part_number The part number
	* @md5sum The MD5 check sum for the upload
	*/
	public function createUpload(
		required string content_type = 'application/octet-stream',
		required string file_name,
		required numeric file_size,
		numeric part_number = 1,
		string md5sum,
		boolean deserialize
	){
		var strURL = 'uploads';
		var sBody = {
			'content_type': arguments.content_type,
			'file_name': arguments.file_name,
			'file_size': arguments.file_size,
			'part_number': arguments.part_number
		};
		if( len( arguments.md5sum ) ){
			structInsert( sBody, 'md5sum', arguments.md5sum );
		}
		
		var serializer = getJSONUtil()
	        .asInteger( "file_size" )
	        .asInteger( "part_number" );
	  	
	  	return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );

	}
	
	/**
	* Mark the upload as finished
	* @upload_response The response from the createUpload function
	*/
	public function completeUpload(
		required struct upload_response,
		boolean deserialize
	){
		var iUploadId = arguments.upload_response.id;
		var strURL = 'uploads/' & iUploadId;
		var sBody = {
			'state': 'finished'
		};
		var serializer = getJSONUtil();
		return makeRequest( method='PATCH', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}



	/*****************************************
	*                 USER                   *
	*****************************************/
	
	/**
	* Fetch the currently logged in user
	*/
	public function user(
		boolean deserialize
	){
		var strURL = 'user';
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Fetch the users the currently logged in user can access
	* @list_id Restricts the list of returned users to only those who have access to a particular list.
	*/
	public function getUsers(
		numeric list_id,
		boolean deserialize
	){
		var strURL = 'users';
		if( len( arguments.list_id ) ){
			strURL = strURL & '?list_id=' & arguments.list_id;
		}
		return makeRequest( url=strURL, deserialize=arguments.deserialize ); 
	}
	
	/*****************************************
	*              WEBHOOKS                  *
	*****************************************/
	
	/**
	* Get all webhooks for a list
	* @list_id The list id
	*/
	public function getWebhooks(
		required numeric list_id,
		boolean deserialize
	){
		var strURL = 'webhooks?list_id=' & arguments.list_id;
		return makeRequest( url=strURL, deserialize=arguments.deserialize );
	}
	
	/**
	* Create a Webhook
	* @list_id The list id
	* @url maximum length is 255 characters
	* @processor_type
	* @configuration can be ""
	*/
	public function createWebhook(
		required numeric list_id,
		required string url,
		required string processor_type = 'generic',
		required string configuration = '',
		boolean deserialize
	){
		var strURL = 'webhooks';
		var sBody = {
			'list_id': arguments.list_id,
			'url': arguments.url,
			'processor_type': arguments.processor_type,
			'configuration': arguments.configuration
		};
		
		var serializer = getJSONUtil()
	        .asInteger( "list_id" );
		
		return makeRequest( method='POST', url=strURL, body=serializer.serialize( sBody ), deserialize=arguments.deserialize );
	}
	
	/**
	* Delete a webhook permanently
	* @webhook_id The webhook id
	* @url maximum length is 255 characters
	* @processor_type
	* @configuration can be ""
	*/
	public function deleteWebhook(
		required numeric webhook_id,
		required numeric revision,
		boolean deserialize
	){
		var strURL = 'webhooks/' & arguments.webhook_id & '?revision=' & arguments.revision;
		return makeRequest( method='DELETE', url=strURL, deserialize=arguments.deserialize );
	}

	
	/*****************************************
	*           Internal Utilities           *
	*****************************************/

	/*
	* Makes the HTTP requests to the API
	* @method Defaults to 'GET'
	* @body The JSON body for payloads
	* @deserialize Returns a CFML struct if set to true, other plain JSON
	* @accessTokenRequired When true (default), it sends the access token in the header
	* @headers An array of data to be sent in the headers.
	*/
	private function makeRequest(
		string method = 'GET',
		required string url,
		string body = '',
		boolean deserialize = false,
		boolean accessTokenRequired = true,
		array headers = []
	){	
		var httpService = new http( method=arguments.method, url=getBaseURL() & arguments.url );
		httpService.addParam( name="Content-Type", type="header", value='application/json' );
		if( arrayLen( arguments.headers ) ){
			for( var header in arguments.headers ){
				httpService.addParam( name=header.key, type="header", value=header.value );
			}
		}
		httpService.addParam( name="X-Client-ID", type="header", value=getClientID() );
		
		if( arguments.accessTokenRequired ){
			httpService.addParam( name="X-Access-Token", type="header", value=getAccessToken() );
		}
		if( len( arguments.body ) && arguments.method NEQ 'GET' ){
			httpService.addParam( type="body", value=arguments.body );
		}
		var result = httpService.send().getPrefix();
		return ( arguments.deserialize ) ? deserializeJSON( result.fileContent ) : result.fileContent;
	}
	
}