require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
    completed_at: Time.now + 5.days
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path
      
      # Assert
      must_respond_with :success
    end
    
    it "can get the root path" do
      # Act
      get root_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      #skip
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end
    
    it "will redirect for an invalid task" do
      # skip
      # Act
      get task_path(-1)
      
      # Assert
      must_respond_with :redirect
    end
  end
  
  describe "new" do
    it "can get the new task page" do

      # Act
      get new_task_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new task" do
      # skip
      
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed_at: nil,
        },
      }
      
      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1
      
      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]
      
      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end
  
  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      get edit_task_path(task.id) # call task, get it's ID, get to the edit path page

      # Assert
      must_respond_with :success #web server responded with 200 ok
      # must_redirect_to edit_task_path(task.id)
    end
    
    it "will respond with redirect when attempting to edit a nonexistant task" do

      get edit_task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end
  
  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      task_hash = {
          task: {
              name: "edited new task",
              description: "edited new task description",
              completed_at: nil,
          },
      }
      task_id = task.id

      expect {
        patch task_path(task_id), params: task_hash
      }.wont_change "Task.count"
      new_task = Task.find(task_id)
      # new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.name).must_equal task_hash[:task][:name]
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
    
    it "will redirect to the root page if given an invalid id" do
      # Your code here
      get task_path(-1)
      # Assert
      must_redirect_to root_path
    end
  end
  
  # Complete these tests for Wave 4
  describe "destroy" do
    # Your tests go here
    it "can destroy a task" do
      # Arrange
      task_1 = Task.new(name: "voteeee", description: "voteeee before election", completed_at: "idk")

      task_1.save
      id = task_1.id

      expect {
        delete task_path(id)
      }.must_change "Task.count", -1

      must_respond_with :redirect
      must_redirect_to tasks_path
    end


    it "will respond with not_found for invalid ids" do
      expect {
        delete task_path(-1)
      }.wont_change "Task.count"

      must_respond_with :not_found
    end
  end
  
  describe "toggle_complete" do
      it "redirects to homepage after a task has been completed" do
        task_id = task.id
        task_complete = {
            task: {
                name: "new task",
                description: "new task description",
                completed_at: Time.now.to_s,
            },
        }
        expect {
          patch complete_task_path(task_id), params: task_complete
        }.wont_change "Task.count"
        new_task = Task.find(task_id)
        expect(new_task.completed_at).must_equal task_complete[:task][:completed_at]

        must_redirect_to tasks_path
      end

    it "will redirect for an invalid task" do
      task_id = -1

      expect {
        patch complete_task_path(-1)
      }.wont_change "Task.count"

      must_redirect_to tasks_path
    end
  end
end
